/**
 * Created by olgam on 2/15/2023.
 */

public class LookupController {

    @AuraEnabled(cacheable=true)
    public static List<sObject> lookUp(String searchTerm, String myObject) {
        String myQuery = null;

        if (searchTerm == null || searchTerm == '') {
            myQuery = 'Select Id, Name from ' + myObject + ' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
        } else {
            myQuery = 'Select Id, Name from ' + myObject + ' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
        }

        List<sObject> lookUpList = database.query(myQuery);

        return lookUpList;
    }
}