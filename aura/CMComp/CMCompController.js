({
    reset: function (cmp) {
        cmp.set("v.requestedSearchKeyword", '');
        cmp.set("v.searchKeyword", '');
    },

    search: function (component) {
        let completedSearchCriteria = component.get("v.searchKeyword");
        component.set("v.requestedSearchKeyword", completedSearchCriteria);
        console.log('searching ' + completedSearchCriteria);
    },

    handleNext: function (component) {
        let pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber + 1);
    },

    handlePrev: function (component) {
        let pageNumber = component.get("v.pageNumber");
        component.set("v.pageNumber", pageNumber - 1);
    },

    setPaginationData: function (component, event) {
        let currentPage = event.getParam('currentPage');
        let pagesAvailable = event.getParam('pagesAvailable');
        let contentSize = event.getParam('contentSize');
        let dataOnPage = event.getParam('dataOnPage');
        component.set("v.pageNumber", currentPage);
        component.set("v.isLastPage", pagesAvailable === currentPage);
        component.set("v.dataSize", contentSize);
        component.set("v.dataOnPage", dataOnPage);
    },

})