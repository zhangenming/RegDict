Object.defineProperty(Object.prototype, "ll", {
  get() {
    console.log(this)
    return this
  },
})
