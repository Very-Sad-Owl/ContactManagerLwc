@IsTest
public class LwcTableControllerTest {

    public static Contact testContactOne;
    public static Contact testContactTwo;
    public static Contact testContactThree;
    public static Contact testContactFour;

    static {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';

        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
        User u = new User(Alias = 'standt', Email = 'standarduser@testorg.com',
                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US', ProfileId = p.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = uniqueUserName);

        System.runAs(u) {
            Account testAccOne = new Account(Name = 'My Account');
            Account testAccTwo = new Account(Name = 'HOYOVERSE');
            Account testAccThree = new Account(Name = 'MY SOFTWARE');
            insert testAccOne;
            insert testAccTwo;
            insert testAccThree;
            testContactOne = new Contact(AccountId = testAccOne.Id, LastName = 'Olegov', Email = 'lnarasimha823@gmail.com',
                    Contact_Level__c = 'Primary', OwnerId = u.Id);
            insert testContactOne;
            testContactTwo = new Contact(AccountId = testAccTwo.Id, LastName = 'Arra', Email = 'sdrzc623@gmail.com',
                    Contact_Level__c = 'Secondary', OwnerId = u.Id);
            insert testContactTwo;
            testContactThree = new Contact(AccountId = testAccThree.Id, LastName = 'Smith', Email = 'avis843@gmail.com',
                    Contact_Level__c = 'Tertiary', OwnerId = u.Id);
            insert testContactThree;
            testContactFour = new Contact(AccountId = testAccThree.Id, LastName = 'AnotherSmith', Email = 'avis343@gmail.com',
                    Contact_Level__c = 'Tertiary', OwnerId = u.Id);
            insert testContactFour;
        }


    }

    @IsTest
    static void testGetContacts() {
        List<Contact> expected = new List<Contact>();
        expected.add(testContactTwo);
        expected.add(testContactOne);
        expected.add(testContactThree);
        expected.add(testContactFour);

        List<Contact> actual = LwcTableController.getContacts();

        System.assertEquals(expected.size(), actual.size());
    }

    @IsTest
    static void testSearchContacts_bySurnamePart() {
        String namePart = 'Oleg';
        Contact expected = testContactOne;

        Contact actual = LwcTableController.searchByNameOrSurname(namePart).get(0);

        System.assertEquals(expected.Id, actual.Id);
    }

    @IsTest
    static void testDeleteContact_existingContant() {
        String deletedId = testContactThree.Id;

        String expected = 'success';

        String actual = LwcTableController.deleteContact(deletedId);

        System.assertEquals(expected, actual);
    }

    @IsTest
    static void testDeleteContact_nonExistingContant() {
        String deletedId = testContactFour.Id;
        Database.delete(deletedId);

        DmlException expectedException;
        Test.startTest();
        String actual = LwcTableController.deleteContact(deletedId);
        Test.stopTest();

        system.assertNotEquals('success', actual);
    }
}