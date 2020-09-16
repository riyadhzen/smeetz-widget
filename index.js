const express = require('express')
const app = express()
const port = process.env.PORT || 3000;

app.use(express.static('public'))

app.listen(port, '0.0.0.0', () => {
  console.log(`Example app listening at http://0.0.0.0:${port}`)
})