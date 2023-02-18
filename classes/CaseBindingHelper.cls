public class CaseBindingHelper {

    public enum CasePriority {
        HIGH, MEDIUM, LOW
    }

    public enum ContactLevel {
        PRIMARY, SECONDARY, TERTIARY
    }

    public class CaseBuilder {
        private Contact contact;
        private String priority;
        private String status;
        private String origin;

        public CaseBuilder withContact(Contact contact) {
            this.contact = contact;
            return this;
        }

        public CaseBuilder withPriority(String priority) {
            this.priority = priority;
            return this;
        }

        public CaseBuilder withStatus(String status) {
            this.status = status;
            return this;
        }

        public CaseBuilder withCaseOrigin(String origin) {
            this.origin = origin;
            return this;
        }

        public Case build() {
            Case newCase = new Case();
            newCase.Contact = this.contact;
            newCase.ContactId = this.contact.Id;
            newCase.Account = this.contact.Account;
            newCase.AccountId = this.contact.AccountId;
            newCase.Priority = this.priority;
            newCase.OwnerId = this.contact.OwnerId;
            newCase.Origin = this.origin;
            newCase.Status = this.status;
            return newCase;
        }
    }

    public static String definePriority(String contactLvl) {
        try {
            switch on ContactLevel.valueOf(contactLvl.capitalize()) {
                when PRIMARY {
                    return String.valueOf(CasePriority.HIGH).toLowerCase();
                }
                when SECONDARY {
                    return String.valueOf(CasePriority.MEDIUM).toLowerCase();
                }
                when TERTIARY {
                    return String.valueOf(CasePriority.LOW).toLowerCase();
                }
                when else {
                    return String.valueOf(CasePriority.MEDIUM).toLowerCase();
                }
            }
        } catch (NoSuchElementException e) {
            return String.valueOf(CasePriority.MEDIUM).toLowerCase();
        }
    }

}