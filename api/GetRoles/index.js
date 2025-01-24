module.exports = async function (context, req) {
    const regexBosch = /(@bosch\.com$)|(@bosch\.io$)/gm;
    const regexPowerCo = /(powerco\.de$)/gm;
    const regexCapGemini = /(capgemini\.com$)/gm;

    roles = {};
    var body = req.body;
    if(body.userDetails !== undefined)
    {
        if(regexBosch.exec(body.userDetails))
        {
            roles = {
                 "roles": ["Bosch"]
            }
        } else if (regexPowerCo.exec(body.userDetails))
        {
            roles = {
                 "roles": ["PowerCo"]
            }
        } else if (regexCapGemini.exec(body.userDetails))
        {
            roles = {
                "roles": ["CapGemini"]
            }
        }
    }
    context.log('JavaScript GetRoles function processed a request from user ' + body.userDetails + ' with answer ' + JSON.stringify(roles));
    context.res.json(roles);
}