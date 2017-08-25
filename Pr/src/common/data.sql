
INSERT INTO result_types VALUES
(DEFAULT, 'score'),
(DEFAULT, 'time'),
(DEFAULT, 'points');


INSERT INTO sexes VALUES
(DEFAULT , 'male'),
(DEFAULT , 'female');

INSERT INTO categories VALUES (DEFAULT, 'Biathlon', DEFAULT, 60, 3, 60, 1, 1, 2);
INSERT INTO categories VALUES (DEFAULT, 'Alpine skiing', DEFAULT, 60, 3, 60, 1, 1, 2);
INSERT INTO categories VALUES (DEFAULT, 'Bobsleight', DEFAULT, 40, 3, 40, 2, 2, 2);
INSERT INTO categories VALUES (DEFAULT, 'Curling', DEFAULT, 50,2, 2, 5, 5, 3);
INSERT INTO categories VALUES (DEFAULT, 'Ice hockey', DEFAULT, 16, 2, 2, 6, 6, 1);
INSERT INTO categories VALUES (DEFAULT, 'Figure skating', DEFAULT, 40, 2, 2, 1, 2, 3);
INSERT INTO categories VALUES (DEFAULT, 'Skeleton', DEFAULT, 30, 3, 20, 1, 1, 2);
INSERT INTO categories VALUES (DEFAULT, 'Competetive progrmming', DEFAULT, 40, 5, 40, 3, 3, 2);
INSERT INTO categories VALUES (DEFAULT, 'Ski jumping', DEFAULT, 50, 10, 50, 1, 1, 3);
INSERT INTO categories VALUES (DEFAULT, 'League of legends', DEFAULT, 16, 2, 2, 5, 5, 1);
INSERT INTO categories VALUES (DEFAULT, 'CS-GO', DEFAULT, 16, 2, 2, 5, 5, 1);
INSERT INTO categories VALUES (DEFAULT, 'Snowboarding', DEFAULT, 40, 3, 40, 5, 5, 3);
INSERT INTO categories VALUES (DEFAULT, 'Speed skating', DEFAULT, 30, 3, 30, 1, 1, 2);
INSERT INTO categories VALUES (DEFAULT, 'Cross-country skiing', DEFAULT, 40, 3, 40, 5, 5, 2);
INSERT INTO categories VALUES (DEFAULT, 'Freestyle skiing', DEFAULT, 40, 3, 40, 1, 1, 2);
INSERT INTO finals VALUES (1, 'final');
INSERT INTO finals VALUES (2, 'semi-final');
INSERT INTO finals VALUES (3, 'eliminations');

INSERT INTO disciplines
  SELECT
    nextval('disciplines_id_seq'),
    sexes.id,
    categories.id
  FROM sexes
    CROSS JOIN categories;


INSERT INTO nationalities VALUES (DEFAULT, 'Ascension Island');
INSERT INTO nationalities VALUES (DEFAULT, 'Andorra');
INSERT INTO nationalities VALUES (DEFAULT, 'United Arab Emirates');
INSERT INTO nationalities VALUES (DEFAULT, 'Afghanistan');
INSERT INTO nationalities VALUES (DEFAULT, 'Antigua and Barbuda');
INSERT INTO nationalities VALUES (DEFAULT, 'Anguilla');
INSERT INTO nationalities VALUES (DEFAULT, 'Albania');
INSERT INTO nationalities VALUES (DEFAULT, 'Armenia');
INSERT INTO nationalities VALUES (DEFAULT, 'Netherlands Antilles');
INSERT INTO nationalities VALUES (DEFAULT, 'Angola');
INSERT INTO nationalities VALUES (DEFAULT, 'Antartica');
INSERT INTO nationalities VALUES (DEFAULT, 'Argentina');
INSERT INTO nationalities VALUES (DEFAULT, 'American Samoa');
INSERT INTO nationalities VALUES (DEFAULT, 'Australia');
INSERT INTO nationalities VALUES (DEFAULT, 'Austria');
INSERT INTO nationalities VALUES (DEFAULT, 'Aruba');
INSERT INTO nationalities VALUES (DEFAULT, 'Azerbaijan');
INSERT INTO nationalities VALUES (DEFAULT, 'Bosnia and Herzegovina');
INSERT INTO nationalities VALUES (DEFAULT, 'Barbados');
INSERT INTO nationalities VALUES (DEFAULT, 'Bangladesh');
INSERT INTO nationalities VALUES (DEFAULT, 'Belgium');
INSERT INTO nationalities VALUES (DEFAULT, 'Burkina Faso');
INSERT INTO nationalities VALUES (DEFAULT, 'Bulgaria');
INSERT INTO nationalities VALUES (DEFAULT, 'Bahrain');
INSERT INTO nationalities VALUES (DEFAULT, 'Burundi');
INSERT INTO nationalities VALUES (DEFAULT, 'Benin');
INSERT INTO nationalities VALUES (DEFAULT, 'Bermuda');
INSERT INTO nationalities VALUES (DEFAULT, 'Brunei Darussalam');
INSERT INTO nationalities VALUES (DEFAULT, 'Bolivia');
INSERT INTO nationalities VALUES (DEFAULT, 'Brazil');
INSERT INTO nationalities VALUES (DEFAULT, 'Bahamas');
INSERT INTO nationalities VALUES (DEFAULT, 'Bhutan');
INSERT INTO nationalities VALUES (DEFAULT, 'Bouvet Island');
INSERT INTO nationalities VALUES (DEFAULT, 'Botswana');
INSERT INTO nationalities VALUES (DEFAULT, 'Belarus');
INSERT INTO nationalities VALUES (DEFAULT, 'Belize');
INSERT INTO nationalities VALUES (DEFAULT, 'Canada');
INSERT INTO nationalities VALUES (DEFAULT, 'Cocos (Keeling) Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Republic Of Kongo');
INSERT INTO nationalities VALUES (DEFAULT, 'Central African Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Prawilna Grupa z Chuty');
INSERT INTO nationalities VALUES (DEFAULT, 'Switzerland');
INSERT INTO nationalities VALUES (DEFAULT, 'Cote d''Ivoire');
INSERT INTO nationalities VALUES (DEFAULT, 'Cook Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Chile');
INSERT INTO nationalities VALUES (DEFAULT, 'Cameroon');
INSERT INTO nationalities VALUES (DEFAULT, 'China');
INSERT INTO nationalities VALUES (DEFAULT, 'Colombia');
INSERT INTO nationalities VALUES (DEFAULT, 'Costa Rica');
INSERT INTO nationalities VALUES (DEFAULT, 'Cuba');
INSERT INTO nationalities VALUES (DEFAULT, 'Cap Verde');
INSERT INTO nationalities VALUES (DEFAULT, 'Christmas Island');
INSERT INTO nationalities VALUES (DEFAULT, 'Cyprus');
INSERT INTO nationalities VALUES (DEFAULT, 'Czeck Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Germany');
INSERT INTO nationalities VALUES (DEFAULT, 'Djibouti');
INSERT INTO nationalities VALUES (DEFAULT, 'Denmark');
INSERT INTO nationalities VALUES (DEFAULT, 'Dominica');
INSERT INTO nationalities VALUES (DEFAULT, 'Dominican Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Algeria');
INSERT INTO nationalities VALUES (DEFAULT, 'Ecuador');
INSERT INTO nationalities VALUES (DEFAULT, 'Estonia');
INSERT INTO nationalities VALUES (DEFAULT, 'Egypt');
INSERT INTO nationalities VALUES (DEFAULT, 'Western Sahara');
INSERT INTO nationalities VALUES (DEFAULT, 'Eritrea');
INSERT INTO nationalities VALUES (DEFAULT, 'Spain');
INSERT INTO nationalities VALUES (DEFAULT, 'Ethiopia');
INSERT INTO nationalities VALUES (DEFAULT, 'Finland');
INSERT INTO nationalities VALUES (DEFAULT, 'Fiji');
INSERT INTO nationalities VALUES (DEFAULT, 'Falkland Islands (Malvina)');
INSERT INTO nationalities VALUES (DEFAULT, 'Federal State of ABCD');
INSERT INTO nationalities VALUES (DEFAULT, 'Faroe Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'France');
INSERT INTO nationalities VALUES (DEFAULT, 'Gabon');
INSERT INTO nationalities VALUES (DEFAULT, 'Grenada');
INSERT INTO nationalities VALUES (DEFAULT, 'Georgia');
INSERT INTO nationalities VALUES (DEFAULT, 'French Guiana');
INSERT INTO nationalities VALUES (DEFAULT, 'Guernsey');
INSERT INTO nationalities VALUES (DEFAULT, 'Ghana');
INSERT INTO nationalities VALUES (DEFAULT, 'Gibraltar');
INSERT INTO nationalities VALUES (DEFAULT, 'Greenland');
INSERT INTO nationalities VALUES (DEFAULT, 'Gambia');
INSERT INTO nationalities VALUES (DEFAULT, 'Guinea');
INSERT INTO nationalities VALUES (DEFAULT, 'Guadeloupe');
INSERT INTO nationalities VALUES (DEFAULT, 'Equatorial Guinea');
INSERT INTO nationalities VALUES (DEFAULT, 'Greece');
INSERT INTO nationalities VALUES (DEFAULT, 'Sandwich Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Guatemala');
INSERT INTO nationalities VALUES (DEFAULT, 'Guam');
INSERT INTO nationalities VALUES (DEFAULT, 'Guinea-Bissau');
INSERT INTO nationalities VALUES (DEFAULT, 'Guyana');
INSERT INTO nationalities VALUES (DEFAULT, 'Hong Kong');
INSERT INTO nationalities VALUES (DEFAULT, 'Heard and McDonald Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Honduras');
INSERT INTO nationalities VALUES (DEFAULT, 'Croatia/Hrvatska');
INSERT INTO nationalities VALUES (DEFAULT, 'Haiti');
INSERT INTO nationalities VALUES (DEFAULT, 'Hungary');
INSERT INTO nationalities VALUES (DEFAULT, 'Indonesia');
INSERT INTO nationalities VALUES (DEFAULT, 'Ireland');
INSERT INTO nationalities VALUES (DEFAULT, 'Israel');
INSERT INTO nationalities VALUES (DEFAULT, 'Isle of Man');
INSERT INTO nationalities VALUES (DEFAULT, 'India');
INSERT INTO nationalities VALUES (DEFAULT, 'British Indian Ocean Territory');
INSERT INTO nationalities VALUES (DEFAULT, 'Iraq');
INSERT INTO nationalities VALUES (DEFAULT, 'Iran (Islamic Republic of)');
INSERT INTO nationalities VALUES (DEFAULT, 'Iceland');
INSERT INTO nationalities VALUES (DEFAULT, 'Italy');
INSERT INTO nationalities VALUES (DEFAULT, 'Jersey');
INSERT INTO nationalities VALUES (DEFAULT, 'Jamaica');
INSERT INTO nationalities VALUES (DEFAULT, 'Jordan');
INSERT INTO nationalities VALUES (DEFAULT, 'Japan');
INSERT INTO nationalities VALUES (DEFAULT, 'Kenya');
INSERT INTO nationalities VALUES (DEFAULT, 'Kyrgyzstan');
INSERT INTO nationalities VALUES (DEFAULT, 'Cambodia');
INSERT INTO nationalities VALUES (DEFAULT, 'Kiribati');
INSERT INTO nationalities VALUES (DEFAULT, 'Comoros');
INSERT INTO nationalities VALUES (DEFAULT, 'Saint Kitts and Nevis');
INSERT INTO nationalities VALUES (DEFAULT,  'Democratic Peoples Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'ABCD');
INSERT INTO nationalities VALUES (DEFAULT, 'Kuwait');
INSERT INTO nationalities VALUES (DEFAULT, 'Cayman Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Kazakhstan');
INSERT INTO nationalities VALUES (DEFAULT, 's Democratic Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Lebanon');
INSERT INTO nationalities VALUES (DEFAULT, 'Saint Lucia');
INSERT INTO nationalities VALUES (DEFAULT, 'Liechtenstein');
INSERT INTO nationalities VALUES (DEFAULT, 'Sri Lanka');
INSERT INTO nationalities VALUES (DEFAULT, 'Liberia');
INSERT INTO nationalities VALUES (DEFAULT, 'Lesotho');
INSERT INTO nationalities VALUES (DEFAULT, 'Lithuania');
INSERT INTO nationalities VALUES (DEFAULT, 'Luxembourg');
INSERT INTO nationalities VALUES (DEFAULT, 'Latvia');
INSERT INTO nationalities VALUES (DEFAULT, 'Libyan Arab Jamahiriya');
INSERT INTO nationalities VALUES (DEFAULT, 'Morocco');
INSERT INTO nationalities VALUES (DEFAULT, 'Monaco');
INSERT INTO nationalities VALUES (DEFAULT, 'Republic of');
INSERT INTO nationalities VALUES (DEFAULT, 'Madagascar');
INSERT INTO nationalities VALUES (DEFAULT, 'Marshall Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Former Yugoslav Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Mali');
INSERT INTO nationalities VALUES (DEFAULT, 'Myanmar');
INSERT INTO nationalities VALUES (DEFAULT, 'Mongolia');
INSERT INTO nationalities VALUES (DEFAULT, 'Macau');
INSERT INTO nationalities VALUES (DEFAULT, 'Northern Mariana Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Martinique');
INSERT INTO nationalities VALUES (DEFAULT, 'Mauritania');
INSERT INTO nationalities VALUES (DEFAULT, 'Montserrat');
INSERT INTO nationalities VALUES (DEFAULT, 'Malta');
INSERT INTO nationalities VALUES (DEFAULT, 'Mauritius');
INSERT INTO nationalities VALUES (DEFAULT, 'Maldives');
INSERT INTO nationalities VALUES (DEFAULT, 'Malawi');
INSERT INTO nationalities VALUES (DEFAULT, 'Mexico');
INSERT INTO nationalities VALUES (DEFAULT, 'Malaysia');
INSERT INTO nationalities VALUES (DEFAULT, 'Mozambique');
INSERT INTO nationalities VALUES (DEFAULT, 'Namibia');
INSERT INTO nationalities VALUES (DEFAULT, 'New Caledonia');
INSERT INTO nationalities VALUES (DEFAULT, 'Niger');
INSERT INTO nationalities VALUES (DEFAULT, 'Norfolk Island');
INSERT INTO nationalities VALUES (DEFAULT, 'Nigeria');
INSERT INTO nationalities VALUES (DEFAULT, 'Nicaragua');
INSERT INTO nationalities VALUES (DEFAULT, 'Netherlands');
INSERT INTO nationalities VALUES (DEFAULT, 'Norway');
INSERT INTO nationalities VALUES (DEFAULT, 'Nepal');
INSERT INTO nationalities VALUES (DEFAULT, 'Nauru');
INSERT INTO nationalities VALUES (DEFAULT, 'Niue');
INSERT INTO nationalities VALUES (DEFAULT, 'New Zealand');
INSERT INTO nationalities VALUES (DEFAULT, 'Oman');
INSERT INTO nationalities VALUES (DEFAULT, 'Panama');
INSERT INTO nationalities VALUES (DEFAULT, 'Peru');
INSERT INTO nationalities VALUES (DEFAULT, 'French Polynesia');
INSERT INTO nationalities VALUES (DEFAULT, 'Papua New Guinea');
INSERT INTO nationalities VALUES (DEFAULT, 'Philippines');
INSERT INTO nationalities VALUES (DEFAULT, 'Pakistan');
INSERT INTO nationalities VALUES (DEFAULT, 'Poland');
INSERT INTO nationalities VALUES (DEFAULT, 'St. Pierre and Miquelon');
INSERT INTO nationalities VALUES (DEFAULT, 'Paraguay');
INSERT INTO nationalities VALUES (DEFAULT, 'Qatar');
INSERT INTO nationalities VALUES (DEFAULT, 'Reunion Island');
INSERT INTO nationalities VALUES (DEFAULT, 'Romania');
INSERT INTO nationalities VALUES (DEFAULT, 'Russian Federation');
INSERT INTO nationalities VALUES (DEFAULT, 'Rwanda');
INSERT INTO nationalities VALUES (DEFAULT, 'Saudi Arabia');
INSERT INTO nationalities VALUES (DEFAULT, 'Solomon Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Seychelles');
INSERT INTO nationalities VALUES (DEFAULT, 'Sudan');
INSERT INTO nationalities VALUES (DEFAULT, 'Sweden');
INSERT INTO nationalities VALUES (DEFAULT, 'Singapore');
INSERT INTO nationalities VALUES (DEFAULT, 'St. Helena');
INSERT INTO nationalities VALUES (DEFAULT, 'Slovenia');
INSERT INTO nationalities VALUES (DEFAULT, 'Svalbard and Jan Mayen Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Slovak Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Sierra Leone');
INSERT INTO nationalities VALUES (DEFAULT, 'San Marino');
INSERT INTO nationalities VALUES (DEFAULT, 'Senegal');
INSERT INTO nationalities VALUES (DEFAULT, 'Somalia');
INSERT INTO nationalities VALUES (DEFAULT, 'Suriname');
INSERT INTO nationalities VALUES (DEFAULT, 'Sao Tome and Principe');
INSERT INTO nationalities VALUES (DEFAULT, 'El Salvador');
INSERT INTO nationalities VALUES (DEFAULT, 'Syrian Arab Republic');
INSERT INTO nationalities VALUES (DEFAULT, 'Swaziland');
INSERT INTO nationalities VALUES (DEFAULT, 'Turks and Ciacos Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Chad');
INSERT INTO nationalities VALUES (DEFAULT, 'French Southern Territories');
INSERT INTO nationalities VALUES (DEFAULT, 'Togo');
INSERT INTO nationalities VALUES (DEFAULT, 'Thailand');
INSERT INTO nationalities VALUES (DEFAULT, 'Tajikistan');
INSERT INTO nationalities VALUES (DEFAULT, 'Tokelau');
INSERT INTO nationalities VALUES (DEFAULT, 'Turkmenistan');
INSERT INTO nationalities VALUES (DEFAULT, 'Tunisia');
INSERT INTO nationalities VALUES (DEFAULT, 'Tonga');
INSERT INTO nationalities VALUES (DEFAULT, 'East Timor');
INSERT INTO nationalities VALUES (DEFAULT, 'Turkey');
INSERT INTO nationalities VALUES (DEFAULT, 'Trinidad and Tobago');
INSERT INTO nationalities VALUES (DEFAULT, 'Tuvalu');
INSERT INTO nationalities VALUES (DEFAULT, 'Taiwan');
INSERT INTO nationalities VALUES (DEFAULT, 'Tanzania');
INSERT INTO nationalities VALUES (DEFAULT, 'Ukraine');
INSERT INTO nationalities VALUES (DEFAULT, 'Uganda');
INSERT INTO nationalities VALUES (DEFAULT, 'United Kingdom');
INSERT INTO nationalities VALUES (DEFAULT, 'United Kingdom');
INSERT INTO nationalities VALUES (DEFAULT, 'US Minor Outlying Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'United States');
INSERT INTO nationalities VALUES (DEFAULT, 'Uruguay');
INSERT INTO nationalities VALUES (DEFAULT, 'Uzbekistan');
INSERT INTO nationalities VALUES (DEFAULT, 'Holy See (City Vatican State)');
INSERT INTO nationalities VALUES (DEFAULT, 'St. Vincent and the Grenadines');
INSERT INTO nationalities VALUES (DEFAULT, 'Venezuela');
INSERT INTO nationalities VALUES (DEFAULT, 'Virgin Islands (British)');
INSERT INTO nationalities VALUES (DEFAULT, 'Virgin Islands (USA)');
INSERT INTO nationalities VALUES (DEFAULT, 'Vietnam');
INSERT INTO nationalities VALUES (DEFAULT, 'Vanuatu');
INSERT INTO nationalities VALUES (DEFAULT, 'Wallis and Futuna Islands');
INSERT INTO nationalities VALUES (DEFAULT, 'Western Samoa');
INSERT INTO nationalities VALUES (DEFAULT, 'Yemen');
INSERT INTO nationalities VALUES (DEFAULT, 'Mayotte');
INSERT INTO nationalities VALUES (DEFAULT, 'Yugoslavia');
INSERT INTO nationalities VALUES (DEFAULT, 'South Africa');
INSERT INTO nationalities VALUES (DEFAULT, 'Zambia');
INSERT INTO nationalities VALUES (DEFAULT, 'Zaire');
INSERT INTO nationalities VALUES (DEFAULT, 'Zimbabwe');




INSERT INTO places VALUES (DEFAULT, 'Stadion Olimpijski "Fiszt"', NULL);
INSERT INTO places VALUES (DEFAULT, 'Pałac lodowy "Bolszoj"');
INSERT INTO places VALUES (DEFAULT, 'Pałac  zimowy "Ajsbierg"');
INSERT INTO places VALUES (DEFAULT, 'Adler-Arena');
INSERT INTO places VALUES (DEFAULT, 'Arena lodowa "Szajba"');
INSERT INTO places VALUES (DEFAULT, 'Centrum "Ledianoj kub"');
INSERT INTO places VALUES (DEFAULT, 'Plac "Miedał Płaza');
















