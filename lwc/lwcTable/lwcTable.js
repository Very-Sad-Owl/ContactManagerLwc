import {LightningElement, track, api} from 'lwc';
import getContacts from '@salesforce/apex/LwcTableController.getContacts';
import deleteContact from '@salesforce/apex/LwcTableController.deleteContact';
import searchByNameOrSurname from '@salesforce/apex/LwcTableController.searchByNameOrSurname';
import LightningConfirm from 'lightning/confirm';
import LightningAlert from 'lightning/alert';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import CONTACT_LEVEL_FIELD from '@salesforce/schema/Contact.Contact_Level__c';
import ACCOUNT_FIELD from '@salesforce/schema/Contact.AccountId';

export default class LwcListEditable extends LightningElement {

    showModal = false;
    @track isEdited = false;
    @track toggleSaveLabel = 'Save';
    @track currentData;
    allData;
    contactFields = [
        NAME_FIELD,
        EMAIL_FIELD,
        CONTACT_LEVEL_FIELD,
        ACCOUNT_FIELD
    ];
    // client-side pagination--------------------------------------
    @api
    pageSize;

    @api
    get pageNumber() {
        return this._pageNumber;
    }

    set pageNumber(value) {
        this._pageNumber = value;
        if (this.currentData) {
            this.currentData = this.updatePage(this.allData);
            this.updateContent(this.currentData);
            this.contentChanged();
        }
    }

    updatePage(unpaged) {
        return unpaged.slice((this._pageNumber - 1) * this.pageSize, this._pageNumber * this.pageSize);
    }

    contentChanged() {
        const contentRetrievedEvent = new CustomEvent(
            'contentChanged', {
                detail: {
                    contentSize: this.allData.length,
                    pagesAvailable: Math.ceil(this.allData.length / this.pageSize),
                    currentPage: this._pageNumber,
                    dataOnPage: this.currentData.length
                }
            });
        console.log(this.allData.length + ' ' + this._pageNumber + ' ' + this.currentData.length);
        this.dispatchEvent(contentRetrievedEvent);
    }

    //--------------------------------------------client-side pagination

    //searching-------------------------------------
    @api
    get searchWord() {
        return this._searchWord;
    }

    set searchWord(value) {
        this._searchWord = value;
        searchByNameOrSurname({searched: value})
            .then(result => {
                console.log(result);
                this.allData = result;
                this._pageNumber = 1;
                this.currentData = this.updatePage(result);
                this.updateContent(this.currentData);
                this.contentChanged();
            })
            .catch(error => {
                this.error = error;
            })
    }

    //----------------------------------------searching

    //sorting------------------------------

    sortOrder = 1;
    sortedColumn;

    sort(event) {
        let sorted = this.allData;
        let nowSortedColumn = event.currentTarget.dataset.id;
        if (this.sortedColumn === nowSortedColumn) {
            this.sortOrder = this.sortOrder === 1 ? -1 : 1;
        } else {
            this.sortOrder = 1;
        }
        if (!this.sortedColumn) {
            this.sortedColumn = event.currentTarget.dataset.id;
        }
        sorted.sort(this.dynamicSort(nowSortedColumn, this.sortOrder));
        this.allData = sorted;
        this.currentData = this.updatePage(sorted);
        this.updateContent(this.currentData);
        this.sortedColumn = event.currentTarget.dataset.id;
    }

    dynamicSort(property, sortOrder) {
        return function (a, b) {
            let result = (a[property] < b[property]) ? -1 : (a[property] > b[property]) ? 1 : 0;
            return result * sortOrder;
        }
    }

    //-----------------------------------sorting
    updateContent(newContent) {
        this.record = newContent;
        for (let i = 0; i < this.record.length; i++) {
            if (this.record[i].AccountId) {
                this.record[i].accountUrl = `/${this.record[i].AccountId}`;
                this.record[i].accountName = this.record[i].Account.Name;
            }
            if (this.record[i].OwnerId) {
                this.record[i].ownerUrl = `/${this.record[i].OwnerId}`;
                this.record[i].ownerName = this.record[i].Owner.Name;
            }
            if (this.record[i].CreatedBy.Id) {
                this.record[i].createdByUrl = `/${this.record[i].CreatedBy.Id}`;
                this.record[i].createdByName = this.record[i].CreatedBy.Name;
            }
            if (this.record[i].Id)
                this.record[i].recordUrl = `/${this.record[i].Id}`;
        }
        this.currentData = this.record;
        this.error = undefined;
    }


    async remove(event) {
        let indexPosition = event.currentTarget.name;
        const recId = event.currentTarget.dataset.id;
        const isRequestConfirmed = await LightningConfirm.open({
            message: `Are you sure you want to delete this contact?`,
            variant: 'headerless',
        });
        if (!isRequestConfirmed) return;
        deleteContact({toDeleteId: recId})
            .then(async () => {
                if (this.allData.length > 1)
                    this.allData.splice(indexPosition, 1);
                this.currentData = this.updatePage(this.allData);
                this.updateContent(this.currentData);
                this.contentChanged();
                this.error = undefined;
                await LightningAlert.open({
                    message: `Record with id ${recId} have been successfully deleted.`,
                    theme: 'success',
                    label: 'Success!'
                });
            })
            .catch(async error => {
                await LightningAlert.open({
                    message: `Record hasn't been deleted. ${error.message}`,
                    theme: 'success',
                    label: 'Success!'
                });
                this.error = error;
            })
    }

    connectedCallback() {
        this.getContactRecords();
    }

    getContactRecords() {
        getContacts()
            .then(result => {
                this.allData = result;
                this.currentData = this.updatePage(result);
                this.updateContent(this.currentData);
                this.contentChanged();
            })
            .catch(error => {
                this.error = error;
                this.record = undefined;
            });
    }

    onDoubleClickEdit() {
        if (this.isEdited) {
            this.isEdited = false;
        } else {
            this.isEdited = true;
        }
    }

    handleCancel() {
        this.isEdited = false;
    }

    //--------------------add form
    async hideFormOnSuccess(event) {
        await LightningAlert.open({
            message: `New record has been inserted. Given id: ${event.target.dataset.recordId}.`,
            theme: 'success',
            label: 'Success!'
        });
        this.showModal = false;
    }

    hideFormOnCancel(event) {
        this.showModal = false;
    }

    openModal() {
        this.showModal = true;
    }

    //add form---------------------------
}