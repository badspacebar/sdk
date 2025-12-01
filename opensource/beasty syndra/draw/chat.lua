local colored_chat_print = function(color, msg)
  return "</font><font color="..color..">"..msg.."</font>"
end

return {
  colored_chat_print = colored_chat_print,
}