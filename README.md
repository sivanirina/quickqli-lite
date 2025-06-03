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

## 📁 Folder Structure

```
quickqli-lite/
├── deployment/            # Deployment instructions and metadata
├── force-app/             # LWC source files
├── screenshots/           # UI screenshots (e.g. ui-overview.png)
├── README.md              # You're here!
└── LICENSE                # MIT License
```

## 🔼 Want More Power: Pagination, Row Selection, Currency Formatting, and more?
> 👉 [Buy the Pro Version on Gumroad](https://gumroad.com/yourproduct) for:

- 🔄 Persistent inline editing with real-time calculations
- 📊 Sorting, filtering & pagination across full product datasets
- 📊 Auto-calculation of total values per item (backend logic)
- 💾 Server-side sync and auto-save draft state
- 🛡️ Role-based visibility & permission control
- 💼 Enterprise-level support & integration service

📩 Email us at **iryna.zasikan@gmail.com** for licensing, demos or questions.

## 🚀 Installation

You can deploy using SFDX:
-If you're using the new sf CLI (recommended for all new projects), and you have a package.xml file inside your deployment/ folder, the best way to deploy is:
```bash
sf deploy project start --target-org <your-org-alias>
```
- If you want to deploy the full force-app source structure:
```bash
sf project deploy start --source-dir force-app --target-org <your-org-alias>
```
- Or if you want to do a dry run first:
```bash
sf project deploy preview --source-dir force-app --target-org <your-org-alias>
```

Or use the metadata zip file in the `deployment/` folder with Salesforce Workbench.

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
