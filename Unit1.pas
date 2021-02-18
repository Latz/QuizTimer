unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus, mmsystem,
  Vcl.AppEvnts, Vcl.Themes, zaehlerForm, SHFolder;

type
  states = (idle, running, stopped);

type
  TForm1 = class(TForm)
    btn_20sec: TButton;
    Timer1: TTimer;
    btn_30sec: TButton;
    btn_start: TButton;
    btn_reset: TButton;
    PopupMenu: TPopupMenu;
    DarkMode: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    KeepOnTop: TMenuItem;
    procedure btn_20secClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btn_30secClick(Sender: TObject);
    procedure btn_startClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btn_resetClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DarkModeClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure ApplicationEvents1Activate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure KeepOnTopClick(Sender: TObject);
  private
    { Private-Deklarationen }
    counter: integer;
    counterStart: integer;
    state: states;
    zaehler: TZaehler;
    init: boolean;
    appFolder: string;
  public
    { Public-Deklarationen }
  const
    version: string = '0.3';
  end;


var
  Form1: TForm1;

implementation

{$R *.dfm}

// ----------------------------------------------------

function GetSpecialFolderPath(CSIDLFolder: Integer): string;
var
   FilePath: array [0..MAX_PATH] of char;
begin
  SHGetFolderPath(0, CSIDLFolder, 0, 0, FilePath);
  Result := FilePath;
end;

// -----------------------------------------------------

procedure TForm1.FormActivate(Sender: TObject);
begin
   state := idle;
  PopupMenu.AutoPopup := True;
    Application.Title := 'XXX'; // Application.Title + ' v' + version;

  end;

// -----------------------------------------------------------------------------

procedure saveUserData();
begin
end;

// -----------------------------------------------------------------------------

procedure TForm1.FormCreate(Sender: TObject);
begin
  zaehler := Tzaehler.Create(nil);
  zaehler.Show;
  init := true;
  if (Sender is TForm1) then
   counterStart := 20;
  appFolder := GetSpecialFolderPath($001c);
//  zaehler.lbl_counter.Caption := '20';

end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  ShowMessage('Right button clicked.');
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  zaehler.BringToFront;
  BringToFront;

  if (init)  then
  begin
    zaehler.Top := Top;
  zaehler.Left := Left+Width+5;
    init := false;
  end;

end;

procedure TForm1.KeepOnTopClick(Sender: TObject);
begin
   ShowMessage(Sender.ToString);

  KeepOnTop.Checked := not KeepOnTop.Checked;
  if (KeepOnTop.Checked) then
  begin
   SetWindowPos(Handle, HWND_TOPMOST, 0,0,0,0, SWP_NOACTIVATE+SWP_NOMOVE+SWP_NOSIZE);
  end
  else
  begin
    SetWindowPos(Handle, HWND_NOTOPMOST, 0,0,0,0, SWP_NOACTIVATE+SWP_NOMOVE+SWP_NOSIZE);
  end;
end;

// ----------------------------------------------------

procedure TForm1.btn_30secClick(Sender: TObject);
begin
  counterStart := 30;
  zaehler.lbl_counter.Color := clWindow;
  zaehler.lbl_counter.Caption := intToStr(counterStart);
end;

// ----------------------------------------------------

procedure TForm1.btn_startClick(Sender: TObject);
begin

  if (state = idle) then
  begin
    btn_start.Caption := 'Stop';
    btn_30sec.Enabled := false;
    btn_20sec.Enabled := false;
    btn_reset.Enabled := false;
    Timer1.Enabled := true;

    zaehler.lbl_counter.Color := clWindow;
    zaehler.lbl_counter.Transparent := false;
    counter := counterStart;
    zaehler.lbl_counter.Caption := intToStr(counter);

    state := running;
  end

  else if (state = running) then
  begin
    state := stopped;
    Timer1.Enabled := false;
    btn_start.Caption := 'Continue';
    btn_reset.Enabled := true;
  end

  else if (state = stopped) then
  begin
    state := running;
    Timer1.Enabled := true;
    btn_start.Caption := 'Stop';
    btn_30sec.Enabled := true;
    btn_20sec.Enabled := true;
    btn_reset.Enabled := false;
  end;

end;
// ----------------------------------------------------
procedure TForm1.Button1Click(Sender: TObject);
begin
PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
end;

procedure TForm1.DarkModeClick(Sender: TObject);
begin
   DarkMode.Checked := not DarkMode.Checked;
   TStyleManager.SetStyle('Amakrits');
end;

// ----------------------------------------------------

procedure TForm1.btn_resetClick(Sender: TObject);
begin
  state := idle;
  counter := counterStart;
  zaehler.lbl_counter.Caption := intToStr(counter);
  btn_start.Caption := 'Start';
  btn_20sec.Enabled := true;
  btn_30sec.Enabled := true;
  zaehler.lbl_counter.Color := clWindow;
  zaehler.lbl_counter.Transparent := false;
end;

// -----------------------------------------------------

procedure TForm1.ApplicationEvents1Activate(Sender: TObject);
begin
  zaehler.BringToFront;
  BringToFront;
end;

procedure TForm1.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  if (Msg.message = WM_RBUTTONDOWN)  then
  begin
     PopupMenu.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
  end;

end;

procedure TForm1.btn_20secClick(Sender: TObject);
begin
  counterStart := 20;
  zaehler.lbl_counter.Color := clWindow;
  zaehler.lbl_counter.Caption := intToStr(counterStart);
end;

// ----------------------------------------------------

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if (counter > 0) then
  begin
    counter := counter - 1;
    zaehler.lbl_counter.Caption := intToStr(counter);
  end
  else
  begin
    state := idle;
    Timer1.Enabled := false;
    btn_start.Enabled := true;
    btn_30sec.Enabled := true;
    btn_20sec.Enabled := true;
  end;

  if (counter <= 5) then
  begin
    zaehler.lbl_counter.Transparent := false;
    zaehler.lbl_counter.Color := clYellow;
  end;
  if (counter = 0) then
  begin
    state := idle;
    zaehler.lbl_counter.Color := clRed;
    btn_start.Caption := 'Start';
    btn_30sec.Enabled := true;
    btn_20sec.Enabled := true;
    btn_reset.Enabled := true;
    Timer1.Enabled := false;
//    if (Sound.Checked) then
//     PlaySound('d:\ftp\antwortbitte.wav',hInstance,SND_ASYNC);
  end;

end;

// ----------------------------------------------------

end.
