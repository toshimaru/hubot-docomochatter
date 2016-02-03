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
  robot.brain.data.chat_context = {}

  is_defined_cmd = (msg) ->
    cmds = [] # list of available hubot commands
    for help in robot.helpCommands()
      cmd = help.split(' ')[1]
      cmds.push(cmd) if cmds.indexOf(cmd) == -1
    cmd = msg.match[1].split(' ')[0]
    cmds.indexOf(cmd) != -1

  get_context = (context_id) ->
    context = {}
    if ctx = robot.brain.data.chat_context[context_id]
      context.context = ctx.context
      context.mode = ctx.mode
    context

  set_context = (context_id, res) ->
    robot.brain.data.chat_context[context_id] =
      context: res.context
      mode: res.mode

  robot.respond /\s(\S+)/i, (msg) ->
    return if is_defined_cmd(msg)
    msg.send "No API key found for hubot-docomochatter" unless process.env.DOCOMO_API_KEY?

    context_id = msg.message.room
    option = get_context(context_id)

    client.create_dialogue(msg.match[1], option)
      .then (response) ->
        set_context(context_id, response)
        msg.send(response.utt)
      .catch (error) ->
        msg.send(error)
