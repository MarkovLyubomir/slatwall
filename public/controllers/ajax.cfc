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
component output="false" accessors="true" {

	property name="fw" type="any";

	property name="addressService" type="any";
	property name="productService" type="any";

	public void function init( required any fw ) {
		setFW( arguments.fw );
	}

	public void function before() {
		getFW().setView("public:main.blank");
	}

	public void function account( struct rc ) {
		param name="rc.propertyList" default="";

		rc.ajaxResponse["account"] = rc.$.slatwall.getAccountData( rc.propertyList );
	}

	public void function cart( struct rc  ) {
		param name="rc.propertyList" default="";

		rc.ajaxResponse["cart"] = rc.$.slatwall.getCartData( rc.propertyList );
	}

	public void function country( required struct rc ) {
		param name="rc.countryCode" type="string" default="";

		var country = getAddressService().getCountry(rc.countryCode);

		// Make sure that the stateCodeOptions are in the variables scope
		country.getStateCodeOptions();

		if(!isNull(country)) {
			rc.ajaxResponse["country"] = country;
		}
	}

	public void function productSkuOptionDetails( required struct rc ) {
		param name="arguments.rc.productID" type="string" default="";
		param name="arguments.rc.selectedOptionIDList" type="string" default="";

		var product = getProductService().getProduct( arguments.rc.productID );

		if(!isNull(product) && product.getActiveFlag() && product.getPublishedFlag()) {
			rc.ajaxResponse["skuOptionDetails"] = product.getSkuOptionDetails( arguments.rc.selectedOptionIDList );
		}
	}

	public void function productSkuSelected(required struct rc){
		param name="arguments.rc.productID" type="string" default="";
		param name="arguments.rc.selectedOptionIDList" type="string" default="";
		var product = getProductService().getProduct( arguments.rc.productID );
		try{
			var sku = product.getSkuBySelectedOptions(arguments.rc.selectedOptionIDList);
			rc.ajaxResponse['skuID'] = sku.getSkuID();
		}catch(any e){
			rc.ajaxResponse['skuID'] = '';
		}
	}

}
