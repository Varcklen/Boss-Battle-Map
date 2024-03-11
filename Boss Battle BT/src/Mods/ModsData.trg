{
  "Id": 50332204,
  "Comment": "",
  "IsScript": true,
  "RunOnMapInit": false,
  "Script": "library ModsData initializer init\r\n\r\n    private function SetMods takes nothing returns nothing\r\n        //Bless\r\n        set udg_base = 0\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0BB'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A03P'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0QI'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0E4'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0BA'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0DJ'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0QL'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0FH'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0FY'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A00A'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0QF'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0Q8'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0QE'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0AK'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0QC'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0FI'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A11B'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A110'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A116'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A115'\r\n        set udg_DB_GoodMod[BaseNum()] = 'A118'//20\r\n        set udg_DB_GoodMod[BaseNum()] = 'A114'//22\r\n        set udg_DB_GoodMod[BaseNum()] = 'A119'//23\r\n        set udg_DB_GoodMod[BaseNum()] = 'A117'//24\r\n        set udg_DB_GoodMod[BaseNum()] = 'A113'//25\r\n        set udg_DB_GoodMod[BaseNum()] = 'A112'//26\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0MK'//27\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0NF'//28\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0P1'//29\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0SY'//30\r\n        set udg_DB_GoodMod[BaseNum()] = 'A00S'//31\r\n        set udg_DB_GoodMod[BaseNum()] = 'A18S'//32\r\n        set udg_DB_GoodMod[BaseNum()] = 'A19M'//33\r\n        set udg_DB_GoodMod[BaseNum()] = 'A1DJ'//34\r\n        //set udg_DB_GoodMod[BaseNum()] = 'A0GU'//34 -- Triad disabled\r\n        set udg_DB_GoodMod[BaseNum()] = 'A0IG'//35\r\n        set udg_DB_GoodMod[BaseNum()] = 'A14F'//36\r\n        set udg_DB_GoodMod[BaseNum()] = 'A14I'//37\r\n        set udg_Database_NumberItems[7] = udg_base\r\n        \r\n        //Curse\r\n        set udg_base = 0\r\n        set udg_DB_BadMod[BaseNum()] = 'A0FX'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0FM'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0HA'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0QA'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0GG'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0H9'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0G9'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0FW'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10W'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10X'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10T'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10U'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10V'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10R'\r\n        set udg_DB_BadMod[BaseNum()] = 'A10Q'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0LW'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0M4'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0MQ'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0MY'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0NL'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0P5'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0SZ'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0T0'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0YT'\r\n        set udg_DB_BadMod[BaseNum()] = 'A00W'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0JR'\r\n        set udg_DB_BadMod[BaseNum()] = 'A0KI'\r\n        set udg_DB_BadMod[BaseNum()] = 'A14O'\r\n        set udg_DB_BadMod[BaseNum()] = 'A14Q'\r\n        set udg_DB_BadMod[BaseNum()] = 'A1CY'\r\n        set udg_DB_BadMod[BaseNum()] = 'A1CZ'//31\r\n        set udg_DB_BadMod[BaseNum()] = 'A1D1'//32\r\n        set udg_Database_NumberItems[22] = udg_base\r\n    endfunction\r\n\r\n    public function init takes nothing returns nothing\r\n        call TimerStart( CreateTimer(), 0.01, false, function SetMods )\r\n    endfunction\r\nendlibrary",
  "Events": [],
  "LocalVariables": [],
  "Conditions": [],
  "Actions": []
}