requires 'perl', '5.008005';

requires 'parent',               '0';
requires 'Amon2',                '0';
requires 'HTTP::AcceptLanguage', '0.01';
requires 'Locale::Maketext',     '0';

on test => sub {
    requires 'Test::More',                 '0.88';
    requires 'Test::WWW::Mechanize::PSGI', '0';
};
