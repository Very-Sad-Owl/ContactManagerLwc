/**
 * Created by olgam on 2/18/2023.
 */

@IsTest
public with sharing class onDeleteContactTest {
    @IsTest
    static void deleteContactWithRelatedCasesTest() {
        Account a = new Account(Name = 'test acc', Phone = '9494146144');
        insert a;
        Contact con = new Contact(AccountId = a.Id, LastName = 'test con', Email = 'lnarasimha823@gmail.com',
                Contact_Level__c = 'Primary');
        insert con;

        Test.startTest();
        delete con;
        Test.stopTest();

        System.assertEquals(0, [SELECT COUNT() FROM Case]);
    }
}