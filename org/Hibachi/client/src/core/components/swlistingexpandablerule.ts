/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

/* SWListingExpandableRule
 * defines a filter, by which to determine what will be expanded
 * supplies the collection config and any other necessary rules for what will be loaded and displayed
 */

class SWListingExpandableRuleController{

    public filterPropertyIdentifier:string;
    public filterComparisonOperator:string; 
    public filterComparisonValue:string;
    
    public hasChildrenCollectionConfigDeferred;
    public hasChildrenCollectionConfigPromise; 
    public childrenCollectionConfig;

    //@ngInject
    constructor(
        public $q
    ){
        this.hasChildrenCollectionConfigDeferred = $q.defer(); 
        this.hasChildrenCollectionConfigPromise = this.hasChildrenCollectionConfigDeferred.promise;
        //why did I need this? 
        this.childrenCollectionConfig = null;
    }

}

class SWListingExpandableRule implements ng.IDirective{
    public restrict:string = 'EA';
    public scope=true;
    public transclude={
        collectionConfig:"?swConfig"    
    };
    public template=`
        <div ng-transclude="collectionConfig"></div> 
    `
    public bindToController={
        childrenCollectionConfig:"=?",
        filterPropertyIdentifier:"@",
        filterComparisonOperator:"@",
        filterComparisonValue:"@"        
    };
    public controller=SWListingExpandableRuleController;
    public controllerAs="swListingExpandableRule";

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            $q
        )=>new SWListingExpandableRule(
            $q
        );
        directive.$inject = [
            '$q'
        ];
        return directive;
    }
    constructor(private $q){

    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
         scope.swListingExpandableRule.hasChildrenCollectionConfigPromise.then(()=>{
                var rule = {
                    filterPropertyIdentifier:scope.swListingExpandableRule.filterPropertyIdentifier,
                    filterComparisonOperator:scope.swListingExpandableRule.filterComparisonOperator, 
                    filterComparisonValue:scope.swListingExpandableRule.filterComparisonValue,
                    childrenCollectionConfig:scope.swListingExpandableRule.childrenCollectionConfig
                };
                
                //TEMP OVERRIDES for TEMP multilisting directive
                if(angular.isDefined(scope.$parent.$parent.swMultiListingDisplay)){
                    var listingDisplayScope = scope.$parent.$parent.swMultiListingDisplay;
                }else if(angular.isDefined(scope.$parent.swListingDisplay)){
                    var listingDisplayScope = scope.$parent.swListingDisplay;
                }
                
                if(angular.isDefined(listingDisplayScope)){
                    listingDisplayScope.expandableRules.push(rule); 
                } else {
                    throw("listing display scope not available to sw-listing-expandable-rule")
                }
         });
    }
}
export{
    SWListingExpandableRule
}