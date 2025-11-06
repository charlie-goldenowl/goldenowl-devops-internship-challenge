const express = require('express')
const routes = require('../routes')

const server = express()
server.use(express.json())

server.use('/', routes)
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'healthy',
    timestamp: new Date().toISOString(),
    version: '1.0.0'
  })
})
module.exports = server
