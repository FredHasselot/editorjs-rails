import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["editor", "input"]
  static values = {
    content: { type: Object, default: {} },
    placeholder: { type: String, default: "Start writing..." }
  }

  async connect() {
    const EditorJS = (await import("@editorjs/editorjs")).default
    const Header = (await import("@editorjs/header")).default
    const List = (await import("@editorjs/list")).default
    const Quote = (await import("@editorjs/quote")).default
    const Delimiter = (await import("@editorjs/delimiter")).default

    const initialData = Object.keys(this.contentValue).length > 0 ? this.contentValue : undefined

    this.editor = new EditorJS({
      holder: this.editorTarget,
      placeholder: this.placeholderValue,
      data: initialData,
      tools: {
        header: { class: Header, config: { levels: [2, 3, 4], defaultLevel: 2 } },
        list: { class: List, inlineToolbar: true },
        quote: { class: Quote, inlineToolbar: true },
        delimiter: Delimiter
      },
      onReady: () => {
        this.editorTarget.classList.add("editorjs--ready")
      }
    })

    this.boundSave = this.save.bind(this)
    const form = this.element.closest("form")
    if (form) {
      form.addEventListener("submit", this.boundSave)
      this.form = form
    }
  }

  async save(event) {
    if (!this.editor) return

    try {
      const data = await this.editor.save()
      this.inputTarget.value = JSON.stringify(data)
    } catch (error) {
      event?.preventDefault()
      console.error("EditorJS save failed:", error)
    }
  }

  async disconnect() {
    if (this.form && this.boundSave) {
      this.form.removeEventListener("submit", this.boundSave)
    }

    if (this.editor) {
      await this.editor.destroy()
      this.editor = null
    }
  }
}
