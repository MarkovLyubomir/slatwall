/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC
	
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
	
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
	
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
	
    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your 
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms 
    of your choice, provided that you follow these specific guidelines: 

	- You also meet the terms and conditions of the license of each 
	  independent module 
	- You must not alter the default display of the Slatwall name or logo from  
	  any part of the application 
	- Your custom code must not alter or create any files inside Slatwall, 
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets 
	the above guidelines as a combined work under the terms of GPL for this program, 
	provided that you include the source code of that other code when and as the 
	GNU GPL requires distribution of source code.
    
    If you modify this program, you may extend this exception to your version 
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	public void function setUp() {
		super.setup();
		
		variables.service = request.slatwallScope.getService("taxService");
	}

	// Tests for addTaxAddressesStructBillingAddressKey()
	public void function addTaxAddressesStructBillingAddressKey_returns_empty_struct_if_no_billingInfo_on_order(){
		//Creates new order then passes new order into addTaxAddressesStructBillingAddressKey() and saves the return data
		var newOrder = request.slatwallScope.newEntity('Order');
		var taxAddressesStruct = variables.service.addTaxAddressesStructBillingAddressKey(newOrder);
		
		//Asserts that the struct that returns is empty
		assert(structIsEmpty(taxAddressesStruct));
	}

	public void function addTaxAddressesStructBillingAddressKey_sets_struct_billingAddress_key_from_order_billingAddress(){
		//Creates a new Address and a new Order then sets the address to the order's billing address
		var address = request.slatwallScope.getService("Address");
		var newOrder = request.slatwallScope.newEntity('Order');
		newOrder.setBillingAddress( address );
		
		//Passes new order into addTaxAddressesStructBillingAddressKey() and saves the return data
		var taxAddressesStruct = variables.service.addTaxAddressesStructBillingAddressKey( newOrder );
		
		//Asserts that the struct returned as the key 'taxBillingAddress'
		assert(structKeyExists(taxAddressesStruct, 'taxBillingAddress'));	
	}
	
	public void function addTaxAddressesStructBillingAddressKey_doesNOT_sets_struct_billingAddress_key_from_order_orderPayments_where_systemCode_NOT_Active(){
		//Creates new order and orderPayment then adds the orderPayment to the order
		var newOrder = request.slatwallScope.newEntity('Order');
		var newOrderPayment = request.slatwallScope.newEntity('OrderPayment');
		newOrder.addOrderPayment(newOrderPayment);
		
		//Sets system code to dumby string for testing
		newOrder.getOrderPayments()[1].getOrderPaymentStatusType().setSystemCode("notActiveTest");
		var taxAddressesStruct = variables.service.addTaxAddressesStructBillingAddressKey(newOrder);
		
		//Asserts that the struct key 'taxBillingAddress' was not created
		assertFalse(structKeyExists(taxAddressesStruct, 'taxBillingAddress'));
	}
	
	//Sets up dumby order
	private any function dumby_order(){
		//Creates new order
		var newOrder = request.slatwallScope.newEntity('Order');
		var i = 1;
		//Iterates twice to create two orderItems with taxApplied
		for(i=1;i<3;i++){
			var newOrderItem = request.slatwallScope.newEntity('OrderItem');
			var taxApplied = request.slatwallScope.newEntity('taxApplied');
			taxApplied.setTaxAmount(2);
			newOrderItem.addAppliedTax(taxApplied);
			newOrder.addOrderItem(newOrderItem);
		}
		//Returns the dumby order
		return newOrder;
	}
	
	// Tests for removeTaxesFromAllOrderItems()
	public void function removeTaxesFromAllOrderItems_iterates_over_orderItems_in_order_and_removes_taxes(){
		//Uses dumby_order() as newOrder
		var newOrder = dumby_order();
		
		//Asserts that the dumby order has taxes
		assertEquals(4, newOrder.getTaxTotal());
		
		//Passes in the new order to remove taxes and asserts taxes were removed
		variables.service.removeTaxesFromAllOrderItems(newOrder);
		assertEquals(0, newOrder.getTaxTotal());
		
	}
	
}
	