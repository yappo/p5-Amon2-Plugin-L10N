requires 'perl', '5.008005';

requires 'parent',                                    '0';
requires 'Amon2',                                     '0';
requires 'HTTP::AcceptLanguage',                      '0.01';
requires 'Locale::Maketext',                          '0';

# for amon2-xgettext.pl
requires 'Locale::Maketext::Extract',                 '0';
requires 'Locale::Maketext::Extract::Plugin::Xslate', '0';
requires 'File::Find::Rule',                          '0';

on test => sub {
    requires 'Test::More',                 '0.88';
    requires 'Test::WWW::Mechanize::PSGI', '0';
};
