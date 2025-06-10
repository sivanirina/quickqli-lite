# ⚡ Quick QLI Lite

**Quick QLI Lite** is a lightweight, one-page Quote Line Item (QLI) creator for Salesforce Lightning Experience. Designed for speed and simplicity, it enables users to quickly add multiple Quote Line Items to a Quote without switching pages or opening modals.

![Quick QLI Lite UI](screenshots/ui-overview.png)

## ✨ Features

- 🔍 **Search-as-you-type** product lookup
- 📂 **Product Family dropdown** filtering
- 🧾 **Inline editing** of:
  - Unit Price
  - Quantity
  - Discount (%)
- ☑️ **Checkbox selection** for multiple Quote Line Items
- 📤 **One-click "Create Items"** button to submit selected rows
- 💡 **List Price reference** displayed for user clarity
- 🧩 **Built 100% in LWC** – no dependency on `lightning-datatable`
- 🚀 **Fast, minimal, and clean** design for Quote creation flow

---

## 📁 Folder Structure

```
quickqli-lite/
├── deployment/            # Deployment instructions and metadata
├── force-app/             # LWC source files
├── screenshots/           # UI screenshots (e.g. ui-overview.png)
├── README.md              # You're here!
└── LICENSE                # MIT License
```

---

## 🔧 Key Development Features & Best Practices

## ✅ Key Features
- **Modular Apex Integration**
  Uses clearly separated Apex methods (getQuoteLineItems, createQuoteLineItems, assignPricebookToQuote) for data retrieval, creation, and quote updating logic.
- **Search & Filter Functionality**
  Provides real-time search and filtering of quote line items by product name and family, improving usability and focus.
- **Dynamic Item Management**
  Allows inline editing of quantity, unit price, and discount fields with automatic tracking of changes.
- **Selective Item Creation**
  Users can select multiple products via checkboxes and create quote line items only from the filtered list of valid, user-modified entries.
- **Price Book Assignment Modal**
  Automatically prompts the user to assign a Price Book if none is associated with the Quote. Includes a modal with Cancel and Save controls.
- **Toast Notifications**
  Utilizes lightning/platformShowToastEvent for user feedback on successful operations.
- **Loading & Error State Management**
  Clearly managed loading spinner and error messages ensure transparency during long or failed operations.

## 🧠 Best Practices Followed
- **Separation of Concerns**
  Business logic is delegated to Apex, keeping the LWC JavaScript focused on UI behavior and state management.
- **Track & Reactive State Management**
  Uses @track and reactive getters to ensure UI updates are triggered efficiently and responsively.
- **Data Validation & Defensive Coding**
  Ensures items meet validation requirements (quantity > 0, unitPrice present, etc.) before proceeding with record creation.
- **Clean and Consistent Code Structure**
  Well-structured functions and consistent variable naming enhance readability and maintainability.
- **Graceful Degradation**
  Includes fallback error messages and ensures the component can still function even if certain data (e.g. families) is missing.
- **UX-Oriented Enhancements**
  Includes conveniences like auto-close modals, delayed refresh, and conditional prompts to guide the user flow intuitively.

---

## 🔐 Want More Power?

The **Pro Version** includes:
- Live row & total calculations
- Pagination (Next/Back)
- Sorting with memory across pages
- Advanced filtering and row selection via checkboxes
- Right-aligned currency formatting based on locale
- Enhanced UI polish
- 💼 Enterprise-level support & integration service

👉 [Buy QuickQLI Pro on Gumroad](https://sivanirina.gumroad.com/l/quickqli)

---

## 🛠 Installation (Lite)
1. Unzip the code
2. Deploy via Salesforce CLI or use Developer Console. Or use the metadata zip file in the `deployment/` folder with Salesforce Workbench.
3. Add to your Lightning Page or Utility Bar

---

## 📄 License
This project is licensed under the MIT License.  
**Author:** Iryna Zasikan  
**Contact:** iryna.zasikan@gmail.com

---

## 📸 Screenshots

| Product Search & Selection |
|----------------------------|
| ![Quick QLI Lite UI](screenshots/ui-overview.png) |

## 🛠️ Requirements

- Salesforce DX enabled org
- Lightning Experience
- Products & Pricebooks set up

## 🧾 License

MIT License – see [LICENSE](./LICENSE) file for details.

---

© 2025 [Iryna Zasikan](mailto:iryna.zasikan@gmail.com)
