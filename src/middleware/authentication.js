
// authentication algorithm
/*
    1. Check if the user sending jwt or not
    2. if user sending jwt
        1. check if jwt valid
        2. if jwt invalid -> go to login
        3. if jwt valid -> is it expired?
        4. if jwt expired -> go to login page
        5. if not, compare user agent stored in db
        6. if not match -> go to login page
        7. if only all match, call next() 
    3. if user is not sending jwt -> go to login
*/

const { verifyJWTToken } = require('../util/jwtToken')
const { getSecondsAfterEpoch } = require('../util/getTimeStamp')
const { testQuery } = require('../../db/connection')
const  chalk = require('chalk')

const authentication = async (req, res, next) => {
    const { jwt } = req.cookies

    try {
        await clearExpiredSession()
    } catch(e) {
        console.log('error clearing expired session', e)
    }

    if (!jwt) {
        res.status(403).redirect('/login')
        return
    }

    const query = 'SELECT * FROM sessions WHERE sessionid = $1'
    try {    
        const { sessionId, session, exp, email } = verifyJWTToken(jwt)
        
        if (getSecondsAfterEpoch() > exp) {
            res.status(403).redirect('/login')
            return
        }

        const params = [sessionId]

        const { rowCount, rows } = await testQuery(query, params)

        if (rowCount === 0) {
            res.status(403).json({ errorMessage: 'Invalid session issued. Please login first' })
            return
        }

        if (session !== rows[0].session && req.headers['user-agent'] !== rows[0].useragent) {
            res.status(403).json({ errorMessage: 'Unauthorized token usage. Please login first.' })
            return
        }

        req.email = email
        next()
        return

    } catch(e) {
        console.log(chalk.white.bold.bgRed(`Unothorized access detected on ${req.path}`))
        res.status(403).redirect('/login')
        return
    }
}

const clearExpiredSession = async () => {
    const query = 'DELETE FROM sessions where $1 > expired'
    const params = [getSecondsAfterEpoch()]

    try {
        await testQuery(query, params)
    } catch(e) {
        console.log(e)
    }

    return
}

module.exports = { authentication }