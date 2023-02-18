@IsTest
public class CaseBindingHelperTest {
    @IsTest
    static void testBuildCase() {
        Contact con = new Contact(AccountId = '0015500000WO1ZiAAL', LastName = 'test con', Email = 'lnarasimha823@gmail.com',
                Contact_Level__c = 'Primary');
        Case newCase = new CaseBindingHelper.CaseBuilder()
                .withContact(con)
                .withPriority(CaseBindingHelper.definePriority(con.Contact_Level__c))
                .withCaseOrigin('New Contact')
                .withStatus('Working')
                .build();
        System.assertEquals('test con', newCase.Contact.LastName);
        System.assertEquals('New Contact', newCase.Origin);
        System.assertEquals('high', newCase.Priority);
        System.assertEquals('Working', newCase.Status);
    }

    @IsTest
    static void testDefinePriority_PrimaryContact_HighPriority() {
        String expected = 'high';
        String actual = CaseBindingHelper.definePriority('Primary');
        System.assertEquals(expected, actual);
    }

    @IsTest
    static void testDefinePriority_SecondaryContact_MediumPriority() {
        String expected = 'medium';
        String actual = CaseBindingHelper.definePriority('Secondary');
        System.assertEquals(expected, actual);
    }

    @IsTest
    static void testDefinePriority_TertiaryContact_LowPriority() {
        String expected = 'low';
        String actual = CaseBindingHelper.definePriority('Tertiary');
        System.assertEquals(expected, actual);
    }

    @IsTest
    static void testDefinePriority_randomString_MeduimPriority() {
        String expected = 'medium';

        String actual = CaseBindingHelper.definePriority('xd');

        System.assertEquals(expected, actual);
    }
}