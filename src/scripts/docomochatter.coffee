# Description:
#   chat with your hubot via Docomo Zatsudan-Taiwa(雑談対話) API
#
# Commands:
#   hubot * (it works only if it doesn't match other commands)
#
# Author:
#   - toshimaru

Docomochatter = require('docomochatter')

module.exports = (robot) ->
  client = new Docomochatter(process.env.DOCOMO_API_KEY)

  is_existing_cmd = (msg) ->
    cmds = [] # list of available hubot commands
    for help in robot.helpCommands()
      cmd = help.split(' ')[1]
      cmds.push(cmd) if cmds.indexOf(cmd) == -1
    cmd = msg.match[1].split(' ')[0]
    cmds.indexOf(cmd) != -1

  robot.respond /(\S+)/i, (msg) ->
    return if is_existing_cmd(msg)

    msg.send "No API key found for hubot-docomochatter" unless process.env.DOCOMO_API_KEY?

    # TODO Keep context

    client.create_dialogue(msg.match[1])
      .then (response) ->
        msg.send response.utt
      .catch (error) ->
        msg.send error
