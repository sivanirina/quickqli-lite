import { LightningElement, api, track } from 'lwc';
import getQuoteLineItems from '@salesforce/apex/QuickQliLiteHelper.getQuoteLineItems';
import createQuoteLineItems from '@salesforce/apex/QuickQliLiteHelper.createQuoteLineItems';
import assignPricebookToQuote from '@salesforce/apex/QuickQliLiteHelper.assignPricebookToQuote';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class QuickQliLite extends LightningElement {
    @api recordId;
    @track items = [];
    @track isLoading = false;
    @track error = '';
    @track showSuccess = false;
    @track selected = []; // Change from selectedArray/selectedIds to a single array

    @track searchTerm = '';
    @track selectedFamily = '';
    @track familyOptions = [];

    @track showPricebookModal = false;
    @track pricebookOptions = [];
    @track selectedPricebook = '';

    connectedCallback() { 
        this.load();
    }

    load() {
        this.isLoading = true;
        getQuoteLineItems({ quoteId: this.recordId })
            .then(data => {
                this.items = (data.items || []).map(item => ({
                    ...item,
                    quantity: Number(item.quantity) || 1,
                    unitPrice: Number(item.unitPrice) || 0,
                    discount: Number(item.discount) || 0
                }));
                this.pricebookOptions = data.pricebookOptions || [];
                this.selectedPricebook = data.assignedPricebookId || '';

                this.error = ''; // clear previous errors
                this.showPricebookModal = !this.selectedPricebook;

                const families = Array.from(new Set(this.items.map(i => i.family).filter(f => f)));
                this.familyOptions = [{ label: 'All', value: '' }, ...families.map(f => ({ label: f, value: f }))];

                this.isLoading = false;
            })
            .catch(e => {
                this.error = e?.body?.message || 'An error occurred while loading data.';
                this.isLoading = false;
            });
    }

    handleSearchChange(event) {
        this.searchTerm = event.target.value;
    }

    handleFamilyChange(event) {
        this.selectedFamily = event.detail.value;
    }

    handleSelect(event) {
        const pricebookEntryId = event.target.dataset.id;
        const isChecked = event.target.checked;

        if (!pricebookEntryId) {
            console.warn('No pricebookEntryId on checkbox input');
            return;
        }

        // Update selected array directly
        if (isChecked) {
            const item = this.items.find(i => i.pricebookEntryId === pricebookEntryId);
            if (item && !this.selected.includes(pricebookEntryId)) {
                this.selected = [...this.selected, pricebookEntryId];
            }
        } else {
            this.selected = this.selected.filter(id => id !== pricebookEntryId);
        }
        console.log('Selected items:', this.selected);
    }

    handleInput(event) {
        const id = event.target.dataset.id;
        const field = event.target.dataset.field;
        const value = event.target.type === 'number' ? Number(event.target.value) : event.target.value;

        this.items = this.items.map(item => {
            if (item.pricebookEntryId === id) {
                return { ...item, [field]: value };
            }
            return item;
        });
    }

    handleCreate() {
        console.log('Selected:', this.selected);
        console.log('Items:', this.items);

        const mappedItems = this.items
            .filter(item => this.selected.includes(item.pricebookEntryId))
            .map(item => {
                console.log('Processing item:', item.pricebookEntryId, 'Quantity:', item.quantity, 'UnitPrice:', item.unitPrice, 'Product2Id:', item.product2Id);
                return {
                    pricebookEntryId: item.pricebookEntryId,
                    product2Id: item.product2Id,
                    quantity: Number(item.quantity) || 1,
                    unitPrice: Number(item.unitPrice) || 0,
                    discount: Number(item.discount) || 0
                };
            });

        console.log('Mapped items before filter:', mappedItems);

        const selectedItems = mappedItems.filter(item =>
            item.pricebookEntryId &&
            item.product2Id &&
            item.unitPrice !== undefined &&
            item.quantity > 0
        );

        console.log('Selected items to create:', selectedItems);

        if (selectedItems.length === 0) {
            this.error = 'Please select at least one valid product with quantity > 0.';
            return;
        }

        this.isLoading = true;
        createQuoteLineItems({
            quoteId: this.recordId,
            items: selectedItems
        })
            .then(() => {
                this.error = '';
                this.showSuccess = true;
                this.selected = [];
            })
            .catch(e => {
                this.error = e?.body?.message || 'Failed to create quote line items.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handlePricebookChange(event) {
        this.selectedPricebook = event.detail.value;
    }

    handleCancelPricebookModal() {
        this.showPricebookModal = false;
    }

    handleSavePricebookModal() {
        this.isLoading = true;
        assignPricebookToQuote({ quoteId: this.recordId, pricebookId: this.selectedPricebook })
            .then(() => {
                this.showPricebookModal = false;
                this.showSuccess = true;
                // Optionally show a toast
                this.dispatchEvent(new ShowToastEvent({
                    title: 'Success',
                    message: 'Quote updated with selected Price Book.',
                    variant: 'success'
                }));
                // Delay, then refresh the page
                setTimeout(() => {
                    window.location.reload();
                }, 1500); // 1.5 seconds delay
            })
            .catch(e => {
                this.error = e?.body?.message || 'Failed to assign Price Book.';
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    get filteredItems() {
        let filtered = this.items;
        if (this.searchTerm) {
            const words = this.searchTerm.toLowerCase().split(/\s+/).filter(Boolean);
            filtered = filtered.filter(item =>
                words.every(word =>
                    (item.productName || '').toLowerCase().includes(word)
                )
            );
        }
        if (this.selectedFamily) {
            filtered = filtered.filter(item => item.family === this.selectedFamily);
        }
        return filtered.map(item => ({
            ...item,
            selected: this.selected.includes(item.pricebookEntryId)
        }));
    }
}
