component output="false" {
	
	public any function init() {
		return this;
	}
	
	public any function read(required string ID, required string entityName) {
		return entityLoad(arguments.entityName, arguments.ID, true);
	}
	
	public any function readByFilename(required string filename, required string entityName){
		return ormExecuteQuery(" from #arguments.entityName# where filename = :filename", {filename=arguments.filename}, true);
	}
	
	public array function list(required string entityName,struct filterCriteria=structNew(),string sortOrder) {
		if(!structIsEmpty(arguments.filterCriteria) and !structKeyExists(arguments,"sortOrder")) {
			return entityLoad(arguments.entityName);
		} else {
			return entityLoad(arguments.entityName,arguments.filterCriteria,arguments.sortOrder);
		}
		
	}
	
	public any function fillSmartList(required any smartList, required any entityName) {
		// Left blank for extended integration to use.
		return arguments.smartList;
	}
	
	public void function delete(required any entity) {
		EntityDelete(arguments.entity);
	}
	
	public any function save(required any entity) {
		EntitySave(arguments.entity);
		//writeDump("THIS WORKED");
		return arguments.entity;
	}
}