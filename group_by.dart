import "package:collection/collection.dart";

main(List<String> args) {
  var data = [
  {
    "id": 1,
    "name": "Leanne Graham",
    "file": "PDF",
    "email": "Sincere@april.biz",
    "date":"2019-05-01"
  },
{
    "id": 2,
    "name": "Avenger",
    "dile": "Mp4",
    "email": "Sincere@april.com",
    "date":"2019-05-01"
  },
    {
    "id": 3,
    "name": "Avenger",
    "file": "Mp3",
    "email": "manog@april.com",
    "date":"2022-05-01"
  },{
    "id": 5,
    "name": "Avenger",
    "file": "ppt",
    "email": "manog@april.com",
    "date":"2022-05-01"
  },
    {
    "id":4,
    "name": "Panchtantara",
    "file": "txt",
    "email": "manog@april.com",
    "date":"2022-05-01"
  },
  ];

 print(data);
  /*output  [{id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}, 
  {id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01},
  {id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01},
  {id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01},
  {id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}]*/
  var newMap = groupBy(data, (Map obj) => obj["name"]);
    print(newMap);
  /*
  {
  Leanne Graham: [
            {id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}
            ],
  Avenger: [
            {id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01},
            {id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01},
            {id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01}
           ],
  Panchtantara: [
          {id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}
          ]
   }
  */
 newMap = groupBy(data, (Map obj) => obj['file']);
   print(newMap);
 /*
 {
  PDF: 
    [
      {id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}
    ],
    null: 
      [
        {id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01}],
    Mp3:
      [ 
        {id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01}
      ],
    ppt: 
      [
        {id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01}
      ],
    txt:
      [
        {id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}
      ]
   }
*/

}


// -- outpot --//
/*
[{id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}, {id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01}, {id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01}, {id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01}, {id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}]

{Leanne Graham: [{id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}], Avenger: [{id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01}, {id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01}, {id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01}], Panchtantara: [{id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}]}
{PDF: [{id: 1, name: Leanne Graham, file: PDF, email: Sincere@april.biz, date: 2019-05-01}], null: [{id: 2, name: Avenger, dile: Mp4, email: Sincere@april.com, date: 2019-05-01}], Mp3: [{id: 3, name: Avenger, file: Mp3, email: manog@april.com, date: 2022-05-01}], ppt: [{id: 5, name: Avenger, file: ppt, email: manog@april.com, date: 2022-05-01}], txt: [{id: 4, name: Panchtantara, file: txt, email: manog@april.com, date: 2022-05-01}]}
*/
