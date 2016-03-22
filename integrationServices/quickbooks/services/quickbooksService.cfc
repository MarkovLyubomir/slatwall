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
component extends="HibachiService" persistent="false" namespace="http://developer.intuit.com/" accessors="true" output="false" {

	property name="accountService";
	property name="settingService";
	property name="hibachiUtilityService";

	/* Example Qwc File
	 <?xml version="1.0"?>
		<QBWCXML>
			<AppName>WCWebService1</AppName>
			<AppID></AppID>
			<AppURL>http://localhost/WCWebService/WCWebService.asmx</AppURL>
			<AppDescription>A short description for WCWebService1</AppDescription>
			<AppSupport>http://developer.intuit.com</AppSupport>
			<UserName>iqbal1</UserName>
			<OwnerID>{57F3B9B1-86F1-4fcc-B1EE-566DE1813D20}</OwnerID>
			<FileID>{90A44FB5-33D9-4815-AC85-BC87A7E7D1EB}</FileID>
			<QBType>QBFS</QBType>
			<Scheduler>
				<RunEveryNMinutes>2</RunEveryNMinutes>
			</Scheduler>
		</QBWCXML>
	 **/

	public function asQBXML(){

	}

	public function getQBWCFile(){

		var fileID = createUUID();

		//temp owner ID for testing
		var ownerID = createUUID();
		var appID = ""; //leave blank
		var appURL= "";


		if(isNumeric(getSettingService().getSettingValue("integrationquickbooksrequestFrequency"))){
			var runEveryNMinutes = getSettingService().getSettingValue("integrationquickbooksrequestFrequency");
		} else {
			var runEveryNMinutes = 15;
		}

		if(len(getSettingService().getSettingValue("integrationquickbooksappname")) > 0){
			var appName = getSettingService().getSettingValue("integrationquickbooksappname");
		} else {
			var appName = "";
		}

		savecontent variable="qwcFile" {
			writeOutput(
				'<?xml version="1.0"?>
					<QBWCXML>' &
					'<AppName>' & appName & '</AppName>' &
					'<AppID>' & appID & '</AppID>' &
					'<AppURL>' & appURL & '</AppURL>' &
					'<AppDescription>' & appURL & '</AppDescription>' &
					'<AppSupport>http://developer.intuit.com</AppSupport>' &
					'<UserName>' & userName & '</UserName>' &
					'<OwnerID>' & ownerID & '</OwnerID>' &
					'<FileID>' & fileID & '</FileID>' &
					'<QBType>QBFS</QBType>' &
					'<Scheduler><RunEveryNMinutes>' & runEveryNMinutes & '</RunEveryNMinutes></Scheduler>' &
					'</QBWCXML>'
			);
		}
		var fileName = fileID & ".qbwc";
		var filePath = getTempDirectory() & "/" & fileName;
		FileWrite(filePath,qwcFile);
		getHibachiUtilityService().downloadFile(fileName,filePath,"qbwc");
	}

	//necessary web service methods
	public array function authenticate(required string strUserName, required string strPassword){
		var tempAccount = getAccountService().newAccount();
		var processObject = tempAccount.getProcessObject("login", {emailAddress=strUserName, password=strPassword});
		var account = getAccountService().processAccount_Login(tempAccount, processObject);

		if(!account.hasErrors()){
			//generate ticket id

			//look to see if there's any sync action that needs to be performed

			//If not keeping a data driven queue, override queue and add one of every action that will need to happen assign it to the ticket id

			var response = [];
		} else {
			var response = ['','nvu'];//non-valid username
		}

		return response;
	}

	public array function sendRequestXML(required string ticket,required string strHCPResponse,required string strCompanyFileName,required string qbXMLCountry,required integer qbXMLMajorVers,required integer qbXMLMinorVers){

		//pop off whatever action needs to be taken and execute it

		return;
	}

	public array function recieveResponseXML(required string ticket,required string response,required string hresult,required string message){

		//confirm the action was sucessful - log it

		return;
	}

	public array function connectionError(required string ticket,required string hresult,required string message){

		//log the error - perform cleanup if need be

		return;
	}

	public array function getLastError(required string ticket){

		//log the error - perform cleanup if need be

		return;
	}

	public array function closeConnection(required string ticket){

		//wipe the queue

		return;
	}

	// ===================== START: Logical Methods ===========================

	// =====================  END: Logical Methods ============================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: DAO Passthrough ===========================

	// ===================== START: Process Methods ===========================

	// =====================  END: Process Methods ============================

	// ====================== START: Save Overrides ===========================

	// ======================  END: Save Overrides ============================

	// ==================== START: Smart List Overrides =======================

	// ====================  END: Smart List Overrides ========================

	// ====================== START: Get Overrides ============================

	// ======================  END: Get Overrides =============================
}
