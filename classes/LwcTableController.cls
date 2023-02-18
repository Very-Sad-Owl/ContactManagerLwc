/**
 * Created by olgam on 2/15/2023.
 */

public with sharing class LwcTableController {

    @AuraEnabled
    public static List<Contact> getContacts (){
        return [SELECT Name, Email, Contact_Level__c, AccountId, Account.Name, OwnerId, Owner.Name, CreatedBy.Id,
                CreatedBy.Name, CreatedDate
        FROM Contact
        ORDER BY Name ASC];
    }

    @AuraEnabled
    public static List<Contact> searchByNameOrSurname(String searched) {
        String searchCriteria = '%' + searched + '%';
        return [SELECT Name, Email, Contact_Level__c, AccountId, Account.Name, OwnerId, Owner.Name, CreatedBy.Id,
                CreatedBy.Name, CreatedDate
        FROM Contact
        WHERE FirstName LIKE :searchCriteria
        OR LastName LIKE :searchCriteria
        ORDER BY Name ASC];
    }

    @AuraEnabled
    public static String deleteContact(String toDeleteId) {
        Database.DeleteResult dr;
        try {
            dr = Database.delete(toDeleteId);
            System.debug('Successfully deleted account with ID: ' + dr.getId());
            return 'success';
        } catch (Exception e) {
            return e.getMessage();
        }
    }

}