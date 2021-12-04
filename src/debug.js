const getT = () => performance.now()
const origins = getT()
let old = 0

Object.defineProperties(Object.prototype, {
  ll: {
    get() {
      console.log(this)
      return this
    },
  },
  lll: {
    get() {
      return (...args) => {
        console.log(...args, this)
        return this
      }
    },
  },
  llt: {
    get() {
      // Array(1e2)
      //   .fill()
      //   .map(() => window)
      var now = getT()
      console.log((now - origins).toFixed(1), (now - old).toFixed(1))
      old = now
      return this
    },
  },
})
