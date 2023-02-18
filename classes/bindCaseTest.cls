@IsTest
public class bindCaseTest {
    @IsTest
    static void addContactWithNewRelatedCase() {
        Account a = new Account(Name = 'test acc', Phone = '9494146144');
        insert a;
        Contact con = new Contact(AccountId = a.Id, LastName = 'test con', Email = 'lnarasimha823@gmail.com',
                Contact_Level__c = 'Primary');

        Test.startTest();
        insert con;
        List<Case> triggered = [SELECT Contact.Name, Origin, Priority FROM Case];
        Test.stopTest();

        System.assertEquals('test con', triggered.get(0).Contact.Name);
        System.assertEquals('New Contact', triggered.get(0).Origin);
        System.assertEquals('High', triggered.get(0).Priority);
    }

    @IsTest
    static void addContactWithNewRelatedCase_withExc() {
        Account a = new Account(Name = 'test acc', Phone = '9494146144');
        insert a;
        Contact con = new Contact(AccountId = a.Id, Email = 'lnarasimha823@gmail.com',
                Contact_Level__c = 'Primary');
        Exception thrown;
        Test.startTest();
        try {
            insert con;
        } catch (Exception e) {
            thrown = e;
        }
        Test.stopTest();

        System.assertNotEquals(null, thrown);
    }
}