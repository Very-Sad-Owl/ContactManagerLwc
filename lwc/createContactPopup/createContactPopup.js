/**
 * Created by olgam on 2/16/2023.
 */

import {api, LightningElement} from 'lwc';

export default class CreateContactPopup extends LightningElement{
    @api
    contactFields;
    errors;

    closePopupSuccess(event) {
        const successEvent = new CustomEvent(
            'inserted', {
                detail: {
                    insertedId: event.detail.id,
                    insertedFields: event.detail.fields
                }
            });
        this.dispatchEvent(successEvent);
    }

    closePopup() {
        const cancelEvent = new CustomEvent(
            'canceled', {});
        this.dispatchEvent(cancelEvent);
    }
}