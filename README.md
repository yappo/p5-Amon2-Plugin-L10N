# NAME

Amon2::Plugin::L10N - L10N support for Amon2

# DESCRIPTION

Amon2::Plugin::L10N is L10N support plugin for Amon2.

# Implementation L10N for your App

## in YourProj.pm

    __PACKAGE__->load_plugins('L10N' => {
        default_lang => 'en',                                  # default is en
        accept_langs => [qw/ en ja zh-tw zh-cn fr /],          # default is ['en']
        po_dir       => 'po',                                  # default is po
    });

## in your YourProj::Web::ViewFunction

    use Text::Xslate ();
    sub l {
        my $string = shift;
        my @args = map { Text::Xslate::html_escape($_) } @_; # escape arguments
        Text::Xslate::mark_raw( YourProj->context->loc($string, @args) );
    }

## in your tmpl/foo.tt

    [% l('Hello! %1', 'username') %]

## in your some class

    package YourProj::M::Foo;
    

    sub bar {
        YourProj->context->loc('hello! %1', $username);
    }

## hook of before language detection

    __PACKAGE__->load_plugins('L10N' => {
        accept_langs          => [qw/ en ja zh-tw zh-cn fr /],
        before_detection_hook => sub {
            my $c = shift;
            return unless ref($c);
    

            my $accept_re = qr/\A(?:en|ja|zh-tw)\z/;
            my $lang = $c->req->param('lang');
            if ($lang && $lang =~ $accept_re) {
                $c->session->set( lang => $lang );
                return $lang;
            } elsif (! defined $lang) {
                $lang = $c->session->get('lang');
                if ($lang && $lang =~ $accept_re) {
                    return $lang;
                }
            }
            $c->session->set( lang => '' );
            return; # through
        },
    });

## hook of after language detection

    __PACKAGE__->load_plugins('L10N' => {
        accept_langs         => [qw/ en ja zh zh-tw zh-cn fr /],
        after_detection_hook => sub {
            my($c, $lang) = shift;
            return 'zh' if $lang =~ /\Azh(?:-.+)\z/;
            return $lang;
        },
    });

## for your CLI

    __PACKAGE__->load_plugins('L10N' => {
        default_lang          => 'ja',
        accept_langs          => [qw/ en ja /],
        before_detection_hook => sub {
            my $c = shift;
            return unless $NEV{CLI_MODE}; # CLI_MODE is example key
            return 'ja' if $ENV{LANG} =~ /ja/i;
            return 'en' if $ENV{LANG} =~ /en/i;
            return; # use default lang
        },
    });

## you can set [Locale::Maketext::Lexicon](http://search.cpan.org/perldoc?Locale::Maketext::Lexicon) options

    # in your MyApp.pm
    __PACKAGE__->load_plugins('L10N' => {
        accept_langs   => [qw/ ja /],
        lexicon_options => {
            _auto => 0,
        },
    });

## you can implement L10N class yourself 

    package L10N;
    use strict;
    use warnings;
    use parent 'Locale::Maketext';
    use File::Spec;
    

    use Locale::Maketext::Lexicon +{
        'ja'     => [ Gettext => File::Spec->catfile('t', 'po', 'ja.po') ],
        _preload => 1,
        _style   => 'gettext',
        _decode  => 1,
    };
    

    # in your MyApp.pm
    __PACKAGE__->load_plugins('L10N' => {
        accept_langs => [qw/ ja /],
        l10n_class   => 'L10N',
    });

# Translation Step

## installing dependent module of amon2-xgettext.pl

    $ cpanm --width-suggests Amon2::Plugin::L10N

dependnt module list in the [cpanfile](http://search.cpan.org/perldoc?cpanfile) file.

## write your application

## run amon2-xgettext.pl

    $ cd your_amon2_proj_base_dir
    $ perl amon2-xgettext.pl en ja fr zh-tw

## edit .po files

    $ vim po/ja.po
    $ vim po/zh-tw.po

# AUTHOR

Kazuhiro Osawa <yappo {at} shibuya {dot} pl>

# COPYRIGHT

Copyright 2013- Kazuhiro Osawa

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[Amon2](http://search.cpan.org/perldoc?Amon2),
[Locale::Maketext::Lexicon](http://search.cpan.org/perldoc?Locale::Maketext::Lexicon),
[HTTP::AcceptLanguage](http://search.cpan.org/perldoc?HTTP::AcceptLanguage)
