WG Lua Scripting Examples
==============================================================

-- Example 0: Hello World!
function wgAction(pos,wid,pid,exe,title,mode)
  WG.Cmd('start cmd /k echo Hello World')
end

-- Example 1: Search Selected Text
function wgAction()
  WG.SendKeys('^{C}')
  WG.Sleep(100)
  local txt = WG.GetClipboardText()
 
  local baidu = 'baidu.com/s?wd='
  local google = 'google.com/search?q='
  local bing = 'bing.com/search?q='
  
  WG.Open('https://'..google..txt)
end

-- Example 2: Message Box
function wgAction(pos,wid,pid,exe,title,mode)
  local msg=User32.GetWindowText(wid)
  local ret=User32.MessageBox(wid, msg, 'hello', luanet.enum(User32.MessageBoxOptions, 'MB_OKCANCEL,MB_TOPMOST'))
  WG.Log('you clicked:' .. ret:ToString())
end

-- Example 3: Toggle Trigger  
function wgAction()
  local trigger = '◑'
  local state = WG.GetTriggerState(nil, trigger)
  state = state == 'off' and 'on' or 'off'
  WG.SetTriggerState(nil, trigger, state)
  WG.Sleep(250)
  WG.ShowToast(trigger..' '..state:upper(), 500, state=='on' and 'green' or 'red')
end

-- Example 4: Pause WG Until Active Window Changed
function wgAction()
  WG.SetPaused(true)
  WG.ShowToast('WG Disabled', 500, 'red')
  local fgWin=User32.GetForegroundWindow()
  repeat WG.Sleep(250)
    until fgWin ~= User32.GetForegroundWindow()
  WG.SetPaused(false)
  WG.ShowToast('WG Enabled', 500, 'green')
end

-- Example 5: Close All File Explorer Windows 
import 'System'
WM_CLOSE=luanet.enum(User32.WindowMessage, 'WM_CLOSE')
function wgAction()
  local wins = WG.FindWinByClass("CabinetWClass")
  for n=0, wins.Count do
    User32.PostMessage(wins[n].Hwnd, WM_CLOSE, IntPtr.Zero, IntPtr.Zero)
  end
end

-- Example 6: Make the monitor brighter
function wgAction(pos)
  local result = WG.SetBrightness(pos, 5) --or -5
  if(result >= 0) then
    WG.ShowToast('☀'..result..'%', 1000);
  end
end