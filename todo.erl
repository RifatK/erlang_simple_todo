-module(todo).
-compile(export_all).

-include_lib("wx/include/wx.hrl").

-define(EXIT,?wxID_EXIT).
-define(OPEN,133).
-define(SAVE,134).

start() ->
     WX = wx:new(),
     Frame = wxFrame:new(wx:null(), ?wxID_ANY, "ToDo App"),
     Text = wxTextCtrl:new(Frame, ?wxID_ANY,
			  [{value,"Add Your Todo List Here or Open Existing"},
			   {style,?wxTE_MULTILINE}]),
     setup(WX,Frame,Text),
     wxFrame:show(Frame),
     captureEvent(Frame,Text),
     wx:destroy().

setup(WX,Frame,Text) ->
     MenuBar = wxMenuBar:new(),
     File = wxMenu:new(),
    
     wxMenu:append(File,?OPEN,"Open saved\tCtrl-O"),
     wxMenu:appendSeparator(File),    
     wxMenu:append(File,?SAVE,"Save\tCtrl-S"),
     wxMenu:append(File,?EXIT,"Quit"),

     wxMenuBar:append(MenuBar,File,"&File"),

     wxFrame:setMenuBar(Frame,MenuBar),

     wxFrame:connect(Frame, command_menu_selected),
     wxFrame:connect(Frame, close_window).

captureEvent(Frame,Text) ->
     receive
     
     #wx{id=?EXIT, event=#wxCommand{type=command_menu_selected}} ->
         wxWindow:close(Frame,[]);
     

     #wx{id=?OPEN, event=#wxCommand{type=command_menu_selected}} ->
	     wxTextCtrl:loadFile(Text,"BLOG"),
	      captureEvent(Frame,Text);

     #wx{id=?SAVE, event=#wxCommand{type=command_menu_selected}} ->
	 wxTextCtrl:saveFile(Text,[{file,"BLOG"}]),
	 captureEvent(Frame,Text)
       
 
     end.
