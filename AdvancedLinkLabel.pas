unit AdvancedLinkLabel;

{*********************
TAdvancedLinkLabel
v. 1.0, 2016, Стрелец Coder
Open Source
**********************
Компонент Delphi расширяющий функционал стандартного LinkLabel путём
добавления обработки события OnClick по умолчанию.
Обработчик по умолчанию автоматически находит тег гиперссылки (при его наличии)
и открывает её.

Работает только с главными страницами web сайтов расположенных
на доменах второго уровня.

Не предназначено для версий ниже XE2

**********************
Delphi component extends the functionality of the standard LinkLabel by
add processing of the OnClick event by default.
The default handler automatically finds the tag of a hyperlink (when available)
and opens it.

Only works with web sites located on the second level domains.

Not intended for versions prior to XE2
}

interface

uses
  Winapi.Windows, System.SysUtils, System.RegularExpressions, System.Classes,
  Vcl.Controls, Vcl.ExtCtrls, ShellAPI;

const
  TagPattern = '<a.+href=".+"(.+>|>).+</a>';
  URLPattern = '(http|https)://\w+\.\w+/';

type
  TAdvancedLinkLabel = class(TLinkLabel)
  public
    constructor Create(AOwner: TComponent); override;
    procedure DefaultClick(Sender: TObject);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('AdvancedLinkLabel', [TAdvancedLinkLabel]);
end;

{ TStreletzCoderLinkLabel }

procedure TAdvancedLinkLabel.DefaultClick(Sender: TObject);
var
  TagRegExp, URLRegExp: TRegEx;
  TagMatch, URLMatch: TMatch;
begin
  // Проверяем наличие тега гиперссылки
  TagRegExp := TRegEx.Create(TagPattern);
  if TagRegExp.IsMatch(Caption) then
  begin
    // Если тег гиперссылки есть, ищем URL
    TagMatch := TagRegExp.Match(Caption);
    URLRegExp := TagRegExp.Create(URLPattern);
    if URLRegExp.IsMatch(TagMatch.Value) then
    begin
      // Если URL найден, открываем ссылку
      URLMatch := URLRegExp.Match(TagMatch.Value);
      ShellExecute(self.Handle, 'open', PWideChar(URLMatch.Value), nil, nil,
        SW_RESTORE);
    end
    else
      exit;
  end
  else
    exit;
end;

constructor TAdvancedLinkLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  self.OnClick := DefaultClick;
end;

end.
