program QuizTimer;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  zaehlerForm in 'zaehlerForm.pas' {Zaehler};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TZaehler, Zaehler);
  Application.Run;
end.
