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
component extends="HibachiService" accessors="true" output="false" {
	variables.appsPath = expandPath('/Slatwall/apps');
	variables.skeletonAppPath = expandPath('/integrationServices/slatwallcms/skeletonapp');
	
	// ===================== START: Logical Methods ===========================
	
	public void function deployApplication(required any app) {
		// copy skeletonapp to /apps/{applicationCodeOrID} 
		if(!directoryExists(arguments.app.getAppPath())){
			directoryCreate(arguments.app.getAppPath());
		}
		getService("hibachiUtilityService").duplicateDirectory(
			source=getSkeletonAppPath(), 
			destination=arguments.app.getAppPath(), 
			overwrite=false, 
			recurse=false, 
			copyContentExclusionList=".svn,.git"
		);
	}
	
	public void function updateCMSApp(required app){
		getService("hibachiUtilityService").copyFile(
			source= replacenocase(getSkeletonAppPath(),'\','/','all') & '/Application.cfc', 
			destination=replacenocase(arguments.app.getAppPath(),'\','/','all') & '/Application.cfc', 
			overwrite=true
		);
	}
	
	public string function getSkeletonAppPath(){
		return variables.skeletonAppPath;
	} 
	
	// =====================  END: Logical Methods ============================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: DAO Passthrough ===========================
	
	// ===================== START: Process Methods ===========================
	
	// =====================  END: Process Methods ============================
	
	// ====================== START: Save Overrides ===========================
	
	public any function saveApp(required any app, struct data={}){
		//deploy the app if the application is new	
		if(arguments.app.isNew()){
			//create directory for app
			if(!directoryExists(variables.appsPath)){
				directoryCreate(variables.appsPath);
			}
			//need to set the appcode to create the app path 
			arguments.app.setAppCode(arguments.data.appCode);
			if(!directoryExists(arguments.app.getAppPath())){
				directoryCreate(arguments.app.getAppPath());
			}
			
			//deploy skeletonApp
			deployApplication(arguments.app);
		}
		arguments.app = super.save(arguments.app, arguments.data);	
		return arguments.app;
	}
	
	public any function processApp_create(required any app, required any processObject){
		//load slatwallCMS Integration
		var slatwallCMSIntegration = getService('integrationService').getIntegrationByIntegrationPackage('slatwallcms');
		arguments.app.setIntegration(slatwallCMSIntegration);
		arguments.app = saveApp(arguments.app, arguments.data);	
		return arguments.app;
	}
	
	// ======================  END: Save Overrides ============================
	
	// ==================== START: Smart List Overrides =======================
	
	// ====================  END: Smart List Overrides ========================
	
	// ====================== START: Get Overrides ============================
	
	// ======================  END: Get Overrides =============================
	
}