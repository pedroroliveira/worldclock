unit UDataHora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, Vcl.StdCtrls, System.DateUtils,
  cxGroupBox, cxRadioGroup, dxBarBuiltInMenu, cxPC, System.Net.URLClient,
  System.Net.HttpClient, System.Net.HttpClientComponent, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;

type
  TfrmClock = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    cxlblDataHora: TcxLabel;
    tmr1: TTimer;
    cxpgcntrl1: TcxPageControl;
    tabFixo: TcxTabSheet;
    tabInternet: TcxTabSheet;
    rgpTZ: TcxRadioGroup;
    cbbContinente: TcxComboBox;
    lbl1: TLabel;
    IdHTTP1: TIdHTTP;
    Label1: TLabel;
    cbbCidades: TcxComboBox;
    procedure tmr1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbbLocalPropertiesChange(Sender: TObject);
    procedure cxpgcntrl1PageChanging(Sender: TObject; NewPage: TcxTabSheet;
      var AllowChange: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbbTimeZonesPropertiesChange(Sender: TObject);
    procedure cbbContinentePropertiesChange(Sender: TObject);
  private
    { Private declarations }
    Agora: TDateTime;
    TextoPagina: TStringList;
    procedure SetaHoraLocal;
    procedure SetaHoraInternet;
  public
    { Public declarations }
  end;

// Define as diversas TimeZones

{$REGION 'TimeZones'}
const
  TimeZones: array[1..416,1..3] of string =
    (('AF','Afghanistan','Asia/Kabul'),
     ('AX','Aland Islands','Europe/Mariehamn'),
     ('AL','Albania','Europe/Tirane'),
     ('DZ','Algeria','Africa/Algiers'),
     ('AS','American Samoa','Pacific/Pago_Pago'),
     ('AD','Andorra','Europe/Andorra'),
     ('AO','Angola','Africa/Luanda'),
     ('AI','Anguilla','America/Anguilla'),
     ('AQ','Antarctica','Antarctica/Casey'),
     ('AQ','Antarctica','Antarctica/Davis'),
     ('AQ','Antarctica','Antarctica/DumontDUrville'),
     ('AQ','Antarctica','Antarctica/Mawson'),
     ('AQ','Antarctica','Antarctica/McMurdo'),
     ('AQ','Antarctica','Antarctica/Palmer'),
     ('AQ','Antarctica','Antarctica/Rothera'),
     ('AQ','Antarctica','Antarctica/Syowa'),
     ('AQ','Antarctica','Antarctica/Troll'),
     ('AQ','Antarctica','Antarctica/Vostok'),
     ('AG','Antigua and Barbuda','America/Antigua'),
     ('AR','Argentina','America/Argentina/Buenos_Aires'),
     ('AR','Argentina','America/Argentina/Catamarca'),
     ('AR','Argentina','America/Argentina/Cordoba'),
     ('AR','Argentina','America/Argentina/Jujuy'),
     ('AR','Argentina','America/Argentina/La_Rioja'),
     ('AR','Argentina','America/Argentina/Mendoza'),
     ('AR','Argentina','America/Argentina/Rio_Gallegos'),
     ('AR','Argentina','America/Argentina/Salta'),
     ('AR','Argentina','America/Argentina/San_Juan'),
     ('AR','Argentina','America/Argentina/San_Luis'),
     ('AR','Argentina','America/Argentina/Tucuman'),
     ('AR','Argentina','America/Argentina/Ushuaia'),
     ('AM','Armenia','Asia/Yerevan'),
     ('AW','Aruba','America/Aruba'),
     ('AU','Australia','Antarctica/Macquarie'),
     ('AU','Australia','Australia/Adelaide'),
     ('AU','Australia','Australia/Brisbane'),
     ('AU','Australia','Australia/Broken_Hill'),
     ('AU','Australia','Australia/Currie'),
     ('AU','Australia','Australia/Darwin'),
     ('AU','Australia','Australia/Eucla'),
     ('AU','Australia','Australia/Hobart'),
     ('AU','Australia','Australia/Lindeman'),
     ('AU','Australia','Australia/Lord_Howe'),
     ('AU','Australia','Australia/Melbourne'),
     ('AU','Australia','Australia/Perth'),
     ('AU','Australia','Australia/Sydney'),
     ('AT','Austria','Europe/Vienna'),
     ('AZ','Azerbaijan','Asia/Baku'),
     ('BS','Bahamas','America/Nassau'),
     ('BH','Bahrain','Asia/Bahrain'),
     ('BD','Bangladesh','Asia/Dhaka'),
     ('BB','Barbados','America/Barbados'),
     ('BY','Belarus','Europe/Minsk'),
     ('BE','Belgium','Europe/Brussels'),
     ('BZ','Belize','America/Belize'),
     ('BJ','Benin','Africa/Porto-Novo'),
     ('BM','Bermuda','Atlantic/Bermuda'),
     ('BT','Bhutan','Asia/Thimphu'),
     ('BO','Bolivia','America/La_Paz'),
     ('BQ','Bonaire, Saint Eustatius and Saba','America/Kralendijk'),
     ('BA','Bosnia and Herzegovina','Europe/Sarajevo'),
     ('BW','Botswana','Africa/Gaborone'),
     ('BR','Brazil','America/Araguaina'),
     ('BR','Brazil','America/Bahia'),
     ('BR','Brazil','America/Belem'),
     ('BR','Brazil','America/Boa_Vista'),
     ('BR','Brazil','America/Campo_Grande'),
     ('BR','Brazil','America/Cuiaba'),
     ('BR','Brazil','America/Eirunepe'),
     ('BR','Brazil','America/Fortaleza'),
     ('BR','Brazil','America/Maceio'),
     ('BR','Brazil','America/Manaus'),
     ('BR','Brazil','America/Noronha'),
     ('BR','Brazil','America/Porto_Velho'),
     ('BR','Brazil','America/Recife'),
     ('BR','Brazil','America/Rio_Branco'),
     ('BR','Brazil','America/Santarem'),
     ('BR','Brazil','America/Sao_Paulo'),
     ('IO','British Indian Ocean Territory','Indian/Chagos'),
     ('VG','British Virgin Islands','America/Tortola'),
     ('BN','Brunei','Asia/Brunei'),
     ('BG','Bulgaria','Europe/Sofia'),
     ('BF','Burkina Faso','Africa/Ouagadougou'),
     ('BI','Burundi','Africa/Bujumbura'),
     ('KH','Cambodia','Asia/Phnom_Penh'),
     ('CM','Cameroon','Africa/Douala'),
     ('CA','Canada','America/Atikokan'),
     ('CA','Canada','America/Blanc-Sablon'),
     ('CA','Canada','America/Cambridge_Bay'),
     ('CA','Canada','America/Creston'),
     ('CA','Canada','America/Dawson'),
     ('CA','Canada','America/Dawson_Creek'),
     ('CA','Canada','America/Edmonton'),
     ('CA','Canada','America/Fort_Nelson'),
     ('CA','Canada','America/Glace_Bay'),
     ('CA','Canada','America/Goose_Bay'),
     ('CA','Canada','America/Halifax'),
     ('CA','Canada','America/Inuvik'),
     ('CA','Canada','America/Iqaluit'),
     ('CA','Canada','America/Moncton'),
     ('CA','Canada','America/Nipigon'),
     ('CA','Canada','America/Pangnirtung'),
     ('CA','Canada','America/Rainy_River'),
     ('CA','Canada','America/Rankin_Inlet'),
     ('CA','Canada','America/Regina'),
     ('CA','Canada','America/Resolute'),
     ('CA','Canada','America/St_Johns'),
     ('CA','Canada','America/Swift_Current'),
     ('CA','Canada','America/Thunder_Bay'),
     ('CA','Canada','America/Toronto'),
     ('CA','Canada','America/Vancouver'),
     ('CA','Canada','America/Whitehorse'),
     ('CA','Canada','America/Winnipeg'),
     ('CA','Canada','America/Yellowknife'),
     ('CV','Cape Verde','Atlantic/Cape_Verde'),
     ('KY','Cayman Islands','America/Cayman'),
     ('CF','Central African Republic','Africa/Bangui'),
     ('TD','Chad','Africa/Ndjamena'),
     ('CL','Chile','America/Santiago'),
     ('CL','Chile','Pacific/Easter'),
     ('CN','China','Asia/Shanghai'),
     ('CN','China','Asia/Urumqi'),
     ('CX','Christmas Island','Indian/Christmas'),
     ('CC','Cocos Islands','Indian/Cocos'),
     ('CO','Colombia','America/Bogota'),
     ('KM','Comoros','Indian/Comoro'),
     ('CK','Cook Islands','Pacific/Rarotonga'),
     ('CR','Costa Rica','America/Costa_Rica'),
     ('HR','Croatia','Europe/Zagreb'),
     ('CU','Cuba','America/Havana'),
     ('CW','Cura�ao','America/Curacao'),
     ('CY','Cyprus','Asia/Nicosia'),
     ('CZ','Czech Republic','Europe/Prague'),
     ('CD','Democratic Republic of the Congo','Africa/Kinshasa'),
     ('CD','Democratic Republic of the Congo','Africa/Lubumbashi'),
     ('DK','Denmark','Europe/Copenhagen'),
     ('DJ','Djibouti','Africa/Djibouti'),
     ('DM','Dominica','America/Dominica'),
     ('DO','Dominican Republic','America/Santo_Domingo'),
     ('TL','East Timor','Asia/Dili'),
     ('EC','Ecuador','America/Guayaquil'),
     ('EC','Ecuador','Pacific/Galapagos'),
     ('EG','Egypt','Africa/Cairo'),
     ('SV','El Salvador','America/El_Salvador'),
     ('GQ','Equatorial Guinea','Africa/Malabo'),
     ('ER','Eritrea','Africa/Asmara'),
     ('EE','Estonia','Europe/Tallinn'),
     ('ET','Ethiopia','Africa/Addis_Ababa'),
     ('FK','Falkland Islands','Atlantic/Stanley'),
     ('FO','Faroe Islands','Atlantic/Faroe'),
     ('FJ','Fiji','Pacific/Fiji'),
     ('FI','Finland','Europe/Helsinki'),
     ('FR','France','Europe/Paris'),
     ('GF','French Guiana','America/Cayenne'),
     ('PF','French Polynesia','Pacific/Gambier'),
     ('PF','French Polynesia','Pacific/Marquesas'),
     ('PF','French Polynesia','Pacific/Tahiti'),
     ('TF','French Southern Territories','Indian/Kerguelen'),
     ('GA','Gabon','Africa/Libreville'),
     ('GM','Gambia','Africa/Banjul'),
     ('GE','Georgia','Asia/Tbilisi'),
     ('DE','Germany','Europe/Berlin'),
     ('DE','Germany','Europe/Busingen'),
     ('GH','Ghana','Africa/Accra'),
     ('GI','Gibraltar','Europe/Gibraltar'),
     ('GR','Greece','Europe/Athens'),
     ('GL','Greenland','America/Danmarkshavn'),
     ('GL','Greenland','America/Godthab'),
     ('GL','Greenland','America/Scoresbysund'),
     ('GL','Greenland','America/Thule'),
     ('GD','Grenada','America/Grenada'),
     ('GP','Guadeloupe','America/Guadeloupe'),
     ('GU','Guam','Pacific/Guam'),
     ('GT','Guatemala','America/Guatemala'),
     ('GG','Guernsey','Europe/Guernsey'),
     ('GN','Guinea','Africa/Conakry'),
     ('GW','Guinea-Bissau','Africa/Bissau'),
     ('GY','Guyana','America/Guyana'),
     ('HT','Haiti','America/Port-au-Prince'),
     ('HN','Honduras','America/Tegucigalpa'),
     ('HK','Hong Kong','Asia/Hong_Kong'),
     ('HU','Hungary','Europe/Budapest'),
     ('IS','Iceland','Atlantic/Reykjavik'),
     ('IN','India','Asia/Kolkata'),
     ('ID','Indonesia','Asia/Jakarta'),
     ('ID','Indonesia','Asia/Jayapura'),
     ('ID','Indonesia','Asia/Makassar'),
     ('ID','Indonesia','Asia/Pontianak'),
     ('IR','Iran','Asia/Tehran'),
     ('IQ','Iraq','Asia/Baghdad'),
     ('IE','Ireland','Europe/Dublin'),
     ('IM','Isle of Man','Europe/Isle_of_Man'),
     ('IL','Israel','Asia/Jerusalem'),
     ('IT','Italy','Europe/Rome'),
     ('CI','Ivory Coast','Africa/Abidjan'),
     ('JM','Jamaica','America/Jamaica'),
     ('JP','Japan','Asia/Tokyo'),
     ('JE','Jersey','Europe/Jersey'),
     ('JO','Jordan','Asia/Amman'),
     ('KZ','Kazakhstan','Asia/Almaty'),
     ('KZ','Kazakhstan','Asia/Aqtau'),
     ('KZ','Kazakhstan','Asia/Aqtobe'),
     ('KZ','Kazakhstan','Asia/Oral'),
     ('KZ','Kazakhstan','Asia/Qyzylorda'),
     ('KE','Kenya','Africa/Nairobi'),
     ('KI','Kiribati','Pacific/Enderbury'),
     ('KI','Kiribati','Pacific/Kiritimati'),
     ('KI','Kiribati','Pacific/Tarawa'),
     ('KW','Kuwait','Asia/Kuwait'),
     ('KG','Kyrgyzstan','Asia/Bishkek'),
     ('LA','Laos','Asia/Vientiane'),
     ('LV','Latvia','Europe/Riga'),
     ('LB','Lebanon','Asia/Beirut'),
     ('LS','Lesotho','Africa/Maseru'),
     ('LR','Liberia','Africa/Monrovia'),
     ('LY','Libya','Africa/Tripoli'),
     ('LI','Liechtenstein','Europe/Vaduz'),
     ('LT','Lithuania','Europe/Vilnius'),
     ('LU','Luxembourg','Europe/Luxembourg'),
     ('MO','Macao','Asia/Macau'),
     ('MK','Macedonia','Europe/Skopje'),
     ('MG','Madagascar','Indian/Antananarivo'),
     ('MW','Malawi','Africa/Blantyre'),
     ('MY','Malaysia','Asia/Kuala_Lumpur'),
     ('MY','Malaysia','Asia/Kuching'),
     ('MV','Maldives','Indian/Maldives'),
     ('ML','Mali','Africa/Bamako'),
     ('MT','Malta','Europe/Malta'),
     ('MH','Marshall Islands','Pacific/Kwajalein'),
     ('MH','Marshall Islands','Pacific/Majuro'),
     ('MQ','Martinique','America/Martinique'),
     ('MR','Mauritania','Africa/Nouakchott'),
     ('MU','Mauritius','Indian/Mauritius'),
     ('YT','Mayotte','Indian/Mayotte'),
     ('MX','Mexico','America/Bahia_Banderas'),
     ('MX','Mexico','America/Cancun'),
     ('MX','Mexico','America/Chihuahua'),
     ('MX','Mexico','America/Hermosillo'),
     ('MX','Mexico','America/Matamoros'),
     ('MX','Mexico','America/Mazatlan'),
     ('MX','Mexico','America/Merida'),
     ('MX','Mexico','America/Mexico_City'),
     ('MX','Mexico','America/Monterrey'),
     ('MX','Mexico','America/Ojinaga'),
     ('MX','Mexico','America/Tijuana'),
     ('FM','Micronesia','Pacific/Chuuk'),
     ('FM','Micronesia','Pacific/Kosrae'),
     ('FM','Micronesia','Pacific/Pohnpei'),
     ('MD','Moldova','Europe/Chisinau'),
     ('MC','Monaco','Europe/Monaco'),
     ('MN','Mongolia','Asia/Choibalsan'),
     ('MN','Mongolia','Asia/Hovd'),
     ('MN','Mongolia','Asia/Ulaanbaatar'),
     ('ME','Montenegro','Europe/Podgorica'),
     ('MS','Montserrat','America/Montserrat'),
     ('MA','Morocco','Africa/Casablanca'),
     ('MZ','Mozambique','Africa/Maputo'),
     ('MM','Myanmar','Asia/Rangoon'),
     ('NA','Namibia','Africa/Windhoek'),
     ('NR','Nauru','Pacific/Nauru'),
     ('NP','Nepal','Asia/Kathmandu'),
     ('NL','Netherlands','Europe/Amsterdam'),
     ('NC','New Caledonia','Pacific/Noumea'),
     ('NZ','New Zealand','Pacific/Auckland'),
     ('NZ','New Zealand','Pacific/Chatham'),
     ('NI','Nicaragua','America/Managua'),
     ('NE','Niger','Africa/Niamey'),
     ('NG','Nigeria','Africa/Lagos'),
     ('NU','Niue','Pacific/Niue'),
     ('NF','Norfolk Island','Pacific/Norfolk'),
     ('KP','North Korea','Asia/Pyongyang'),
     ('MP','Northern Mariana Islands','Pacific/Saipan'),
     ('NO','Norway','Europe/Oslo'),
     ('OM','Oman','Asia/Muscat'),
     ('PK','Pakistan','Asia/Karachi'),
     ('PW','Palau','Pacific/Palau'),
     ('PS','Palestinian Territory','Asia/Gaza'),
     ('PS','Palestinian Territory','Asia/Hebron'),
     ('PA','Panama','America/Panama'),
     ('PG','Papua New Guinea','Pacific/Bougainville'),
     ('PG','Papua New Guinea','Pacific/Port_Moresby'),
     ('PY','Paraguay','America/Asuncion'),
     ('PE','Peru','America/Lima'),
     ('PH','Philippines','Asia/Manila'),
     ('PN','Pitcairn','Pacific/Pitcairn'),
     ('PL','Poland','Europe/Warsaw'),
     ('PT','Portugal','Atlantic/Azores'),
     ('PT','Portugal','Atlantic/Madeira'),
     ('PT','Portugal','Europe/Lisbon'),
     ('PR','Puerto Rico','America/Puerto_Rico'),
     ('QA','Qatar','Asia/Qatar'),
     ('CG','Republic of the Congo','Africa/Brazzaville'),
     ('RE','Reunion','Indian/Reunion'),
     ('RO','Romania','Europe/Bucharest'),
     ('RU','Russia','Asia/Anadyr'),
     ('RU','Russia','Asia/Chita'),
     ('RU','Russia','Asia/Irkutsk'),
     ('RU','Russia','Asia/Kamchatka'),
     ('RU','Russia','Asia/Khandyga'),
     ('RU','Russia','Asia/Krasnoyarsk'),
     ('RU','Russia','Asia/Magadan'),
     ('RU','Russia','Asia/Novokuznetsk'),
     ('RU','Russia','Asia/Novosibirsk'),
     ('RU','Russia','Asia/Omsk'),
     ('RU','Russia','Asia/Sakhalin'),
     ('RU','Russia','Asia/Srednekolymsk'),
     ('RU','Russia','Asia/Ust-Nera'),
     ('RU','Russia','Asia/Vladivostok'),
     ('RU','Russia','Asia/Yakutsk'),
     ('RU','Russia','Asia/Yekaterinburg'),
     ('RU','Russia','Europe/Kaliningrad'),
     ('RU','Russia','Europe/Moscow'),
     ('RU','Russia','Europe/Samara'),
     ('RU','Russia','Europe/Simferopol'),
     ('RU','Russia','Europe/Volgograd'),
     ('RW','Rwanda','Africa/Kigali'),
     ('BL','Saint Barth�lemy','America/St_Barthelemy'),
     ('SH','Saint Helena','Atlantic/St_Helena'),
     ('KN','Saint Kitts and Nevis','America/St_Kitts'),
     ('LC','Saint Lucia','America/St_Lucia'),
     ('MF','Saint Martin','America/Marigot'),
     ('PM','Saint Pierre and Miquelon','America/Miquelon'),
     ('VC','Saint Vincent and the Grenadines','America/St_Vincent'),
     ('WS','Samoa','Pacific/Apia'),
     ('SM','San Marino','Europe/San_Marino'),
     ('ST','Sao Tome and Principe','Africa/Sao_Tome'),
     ('SA','Saudi Arabia','Asia/Riyadh'),
     ('SN','Senegal','Africa/Dakar'),
     ('RS','Serbia','Europe/Belgrade'),
     ('SC','Seychelles','Indian/Mahe'),
     ('SL','Sierra Leone','Africa/Freetown'),
     ('SG','Singapore','Asia/Singapore'),
     ('SX','Sint Maarten','America/Lower_Princes'),
     ('SK','Slovakia','Europe/Bratislava'),
     ('SI','Slovenia','Europe/Ljubljana'),
     ('SB','Solomon Islands','Pacific/Guadalcanal'),
     ('SO','Somalia','Africa/Mogadishu'),
     ('ZA','South Africa','Africa/Johannesburg'),
     ('GS','South Georgia and the South Sandwich Islands','Atlantic/South_Georgia'),
     ('KR','South Korea','Asia/Seoul'),
     ('SS','South Sudan','Africa/Juba'),
     ('ES','Spain','Africa/Ceuta'),
     ('ES','Spain','Atlantic/Canary'),
     ('ES','Spain','Europe/Madrid'),
     ('LK','Sri Lanka','Asia/Colombo'),
     ('SD','Sudan','Africa/Khartoum'),
     ('SR','Suriname','America/Paramaribo'),
     ('SJ','Svalbard and Jan Mayen','Arctic/Longyearbyen'),
     ('SZ','Swaziland','Africa/Mbabane'),
     ('SE','Sweden','Europe/Stockholm'),
     ('CH','Switzerland','Europe/Zurich'),
     ('SY','Syria','Asia/Damascus'),
     ('TW','Taiwan','Asia/Taipei'),
     ('TJ','Tajikistan','Asia/Dushanbe'),
     ('TZ','Tanzania','Africa/Dar_es_Salaam'),
     ('TH','Thailand','Asia/Bangkok'),
     ('TG','Togo','Africa/Lome'),
     ('TK','Tokelau','Pacific/Fakaofo'),
     ('TO','Tonga','Pacific/Tongatapu'),
     ('TT','Trinidad and Tobago','America/Port_of_Spain'),
     ('TN','Tunisia','Africa/Tunis'),
     ('TR','Turkey','Europe/Istanbul'),
     ('TM','Turkmenistan','Asia/Ashgabat'),
     ('TC','Turks and Caicos Islands','America/Grand_Turk'),
     ('TV','Tuvalu','Pacific/Funafuti'),
     ('VI','U.S. Virgin Islands','America/St_Thomas'),
     ('UG','Uganda','Africa/Kampala'),
     ('UA','Ukraine','Europe/Kiev'),
     ('UA','Ukraine','Europe/Uzhgorod'),
     ('UA','Ukraine','Europe/Zaporozhye'),
     ('AE','United Arab Emirates','Asia/Dubai'),
     ('GB','United Kingdom','Europe/London'),
     ('US','United States','America/Adak'),
     ('US','United States','America/Anchorage'),
     ('US','United States','America/Boise'),
     ('US','United States','America/Chicago'),
     ('US','United States','America/Denver'),
     ('US','United States','America/Detroit'),
     ('US','United States','America/Indiana/Indianapolis'),
     ('US','United States','America/Indiana/Knox'),
     ('US','United States','America/Indiana/Marengo'),
     ('US','United States','America/Indiana/Petersburg'),
     ('US','United States','America/Indiana/Tell_City'),
     ('US','United States','America/Indiana/Vevay'),
     ('US','United States','America/Indiana/Vincennes'),
     ('US','United States','America/Indiana/Winamac'),
     ('US','United States','America/Juneau'),
     ('US','United States','America/Kentucky/Louisville'),
     ('US','United States','America/Kentucky/Monticello'),
     ('US','United States','America/Los_Angeles'),
     ('US','United States','America/Menominee'),
     ('US','United States','America/Metlakatla'),
     ('US','United States','America/New_York'),
     ('US','United States','America/Nome'),
     ('US','United States','America/North_Dakota/Beulah'),
     ('US','United States','America/North_Dakota/Center'),
     ('US','United States','America/North_Dakota/New_Salem'),
     ('US','United States','America/Phoenix'),
     ('US','United States','America/Sitka'),
     ('US','United States','America/Yakutat'),
     ('US','United States','Pacific/Honolulu'),
     ('UM','United States Minor Outlying Islands','Pacific/Johnston'),
     ('UM','United States Minor Outlying Islands','Pacific/Midway'),
     ('UM','United States Minor Outlying Islands','Pacific/Wake'),
     ('UY','Uruguay','America/Montevideo'),
     ('UZ','Uzbekistan','Asia/Samarkand'),
     ('UZ','Uzbekistan','Asia/Tashkent'),
     ('VU','Vanuatu','Pacific/Efate'),
     ('VA','Vatican','Europe/Vatican'),
     ('VE','Venezuela','America/Caracas'),
     ('VN','Vietnam','Asia/Ho_Chi_Minh'),
     ('WF','Wallis and Futuna','Pacific/Wallis'),
     ('EH','Western Sahara','Africa/El_Aaiun'),
     ('YE','Yemen','Asia/Aden'),
     ('ZM','Zambia','Africa/Lusaka'),
     ('ZW','Zimbabwe','Africa/Harare'));
{$ENDREGION}

var
  frmClock: TfrmClock;

implementation

{$R *.dfm}

procedure TfrmClock.cbbContinentePropertiesChange(Sender: TObject);
var
  i,j: Integer;
  sLcCidade: string;
begin
  // Seta Cidades deste Continente
  cbbCidades.Properties.Items.Clear;
  for i := 1 to 416 do
  begin
    j := Pos(cbbContinente.Text+'/',TimeZones[i,3]);
    if j > 0 then
    begin
      sLcCidade := TimeZones[i,3];
      sLcCidade := Copy(sLcCidade,Pos('/',sLcCidade)+1,100);
      cbbCidades.Properties.Items.Add(sLcCidade);
    end;
  end;
  cbbCidades.ItemIndex := 0;
end;

procedure TfrmClock.cbbLocalPropertiesChange(Sender: TObject);
begin
  SetaHoraLocal;
end;

procedure TfrmClock.cbbTimeZonesPropertiesChange(Sender: TObject);
begin
  if cxpgcntrl1.ActivePage = tabInternet then
    SetaHoraInternet;
end;

procedure TfrmClock.cxpgcntrl1PageChanging(Sender: TObject;
  NewPage: TcxTabSheet; var AllowChange: Boolean);
begin
  if NewPage = tabFixo then
    SetaHoraLocal
  else
    SetaHoraInternet;
end;

procedure TfrmClock.FormCreate(Sender: TObject);
begin
  TextoPagina := TStringList.Create;
end;

procedure TfrmClock.FormShow(Sender: TObject);
var
  i: Integer;
  sLcContinente: string;
begin
  SetaHoraLocal;
  cbbContinente.Properties.Items.Clear;
  for i := 1 to 416 do
  begin
    // Adiciona Locais
    sLcContinente := TimeZones[i,3];
    sLcContinente := Copy(sLcContinente,1,Pos('/',sLcContinente)-1);
    if cbbContinente.Properties.Items.IndexOf(sLcContinente) < 0 then
      cbbContinente.Properties.Items.Add(sLcContinente);
  end;
  cbbContinente.ItemIndex := 0;
  cbbContinentePropertiesChange(nil);
end;

procedure TfrmClock.SetaHoraInternet;
var
  MemoryStream:TMemoryStream;
  sLcPagina: string;
  i, j: Integer;
  tm: Int64;
begin
  MemoryStream := TMemoryStream.Create;

  sLcPagina := 'http://api.timezonedb.com/?zone='+cbbContinente.Text+'/'+cbbCidades.Text+'&key=KUOC0QJEUKKY';

  try
    IdHTTP1.Get(sLcPagina, MemoryStream);
    i := 1;
  except
    on E : Exception do
    begin
      i := 0;
      ShowMessage('Erro ao buscar timezone time ['+E.ClassName+' - '+E.Message+']');
      MemoryStream.Free;
    end;
  end;
  if i > 0 then
  begin
    TextoPagina.Clear;
    MemoryStream.Position := 0;
    TextoPagina.LoadFromStream(MemoryStream);
    MemoryStream.Free;
    sLcPagina := LowerCase(TextoPagina.Text);
    i := Pos('<timestamp>', sLcPagina);   // <timestamp>123</timestamp>
    if i > 0 then
    begin
      j := Pos('</timestamp>', sLcPagina);
      if j > i then
      begin
        j := j - (i+11);
        tm := StrToInt64Def(Copy(sLcPagina,i+11,j),0);
        Agora := UnixToDateTime(tm);
      end;
    end;
  end;
end;

procedure TfrmClock.SetaHoraLocal;
var
  Incremento: Integer;
begin
  Agora := Now;
  Incremento := 0;
  if rgpTZ.ItemIndex = 0 then
    Incremento := 4
  else
  if rgpTZ.ItemIndex = 1 then
    Incremento := -1
  else
  if rgpTZ.ItemIndex = 2 then
    Incremento := -4
  else
  if rgpTZ.ItemIndex = 4 then
    Incremento := 11
  else
  if rgpTZ.ItemIndex = 5 then
    Incremento := 12;

  Agora := IncHour(Agora,Incremento);
end;

procedure TfrmClock.tmr1Timer(Sender: TObject);
begin
  Agora := IncSecond(Agora,1);
  cxlblDataHora.Caption := FormatDateTime('DD/MM/YYYY HH:NN:SS', Agora);
end;

end.
