@istest
public class LookupControllerTest {
    public static Account testAccOne;
    public static Account testAccTwo;
    public static Account testAccThree;

    static {
        testAccOne = new Account(Name = 'My Account');
        testAccTwo = new Account(Name = 'HOYOVERSE');
        testAccThree = new Account(Name = 'MY SOFTWARE');
        insert testAccOne;
        insert testAccTwo;
        insert testAccThree;
    }

    @IsTest
    static void testLookup_onAccountsWithoutSearchTerm() {
        String searchTerm = '';
        String objectType = 'Account';

        List<sObject> actual = LookupController.lookUp(searchTerm, objectType);

        System.assertEquals(3, actual.size());
    }

    @IsTest
    static void testLookup_onAccountsWithSearchTerm() {
        String searchTerm = 'My';
        String objectType = 'Account';

        List<sObject> actual = LookupController.lookUp(searchTerm, objectType);

        System.assertEquals(2, actual.size());
    }
}