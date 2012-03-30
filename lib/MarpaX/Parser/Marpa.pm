package MarpaX::Parser::Marpa;

use strict;
use warnings;

use Marpa::XS;
use MarpaX::Simple::Lexer;

my %tokens = (
       Name                           => qr/(?^:(\w+))/,
       DeclareOp                      => qr/(?^:::=)/,
       Plus                           => '+',
       Star                           => '*',
       CB                             => qr/(?^:{{)/,
       CE                             => qr/(?^:}})/,
       Code                           => qr/(?^:(?<!{{)\s*(.+)\s*(?=}}))/,
       SLASH                          => '/',
       EQ                             => '=',
       RX                             => qr/(?^:(?<!\/)(.+)(?=(?<!\/)))/,
       Char                           => qr/(?^:\$(.))/,
       Space                          => qr/(?^:[ \r\n]+)/,
       Comment                        => qr/(?^:\#.*$)/,
);
sub MarpaX::Parser::Marpa::Actions::Lhs_0 {
	shift; return [ lhs => $_[0] ]           
}

sub MarpaX::Parser::Marpa::Actions::Decl_0 {
	push @{$_[0]->{rules}}, $_[1] 
}

sub MarpaX::Parser::Marpa::Actions::Decl_1 {
	push @{$_[0]->{tokens}}, $_[1] 
}

sub MarpaX::Parser::Marpa::Actions::NamePart_0 {
	shift; return $_[1]; 
}

sub MarpaX::Parser::Marpa::Actions::NamePart_1 {
	shift; return { token => $_[1] }; 
}

sub MarpaX::Parser::Marpa::Actions::Names_0 {
	shift; return [ @_ ];                    
}

sub MarpaX::Parser::Marpa::Actions::Rhs_0 {
	shift; return [ rhs => $_[0] ]           
}

sub MarpaX::Parser::Marpa::Actions::Rhs_1 {
	shift; return [ rhs => $_[0], min => 0 ] 
}

sub MarpaX::Parser::Marpa::Actions::Rhs_2 {
	shift; return [ rhs => $_[0], min => 1 ] 
}

sub MarpaX::Parser::Marpa::Actions::Parser_0 {
	return $_[0]; 
}

sub MarpaX::Parser::Marpa::Actions::WS_0 {
	
}

sub MarpaX::Parser::Marpa::Actions::WS_1 {
	
}

sub MarpaX::Parser::Marpa::Actions::TokenRule_0 {
	shift; return { @{$_[0]}, regex => qr/$_[5]/ } 
}

sub MarpaX::Parser::Marpa::Actions::TokenRule_1 {
	shift; return { @{$_[0]}, 'char' => $_[4] } 
}

sub MarpaX::Parser::Marpa::Actions::Rule_0 {
	shift; return { @{$_[0]}, @{$_[4]} }     
}

sub MarpaX::Parser::Marpa::Actions::Rule_1 {
	shift; return { @{$_[0]}, @{$_[4]}, code => $_[7] }     
}

sub create_grammar {
    my $grammar = Marpa::XS::Grammar->new(
        {   start   => 'Parser',
            actions => 'MarpaX::Parser::Marpa::Actions',

          'rules' => [
                       {
                         'min' => 1,
                         'rhs' => [
                                    'Decl'
                                  ],
                         'lhs' => 'Parser',
                         'action' => 'Parser_0'
                       },
                       {
                         'rhs' => [
                                    'Rule',
                                    'WS'
                                  ],
                         'lhs' => 'Decl',
                         'action' => 'Decl_0'
                       },
                       {
                         'rhs' => [
                                    'TokenRule',
                                    'WS'
                                  ],
                         'lhs' => 'Decl',
                         'action' => 'Decl_1'
                       },
                       {
                         'rhs' => [
                                    'Lhs',
                                    'WS',
                                    'EQ',
                                    'WS',
                                    'SLASH',
                                    'RX',
                                    'SLASH'
                                  ],
                         'lhs' => 'TokenRule',
                         'action' => 'TokenRule_0'
                       },
                       {
                         'rhs' => [
                                    'Lhs',
                                    'WS',
                                    'EQ',
                                    'WS',
                                    'Char'
                                  ],
                         'lhs' => 'TokenRule',
                         'action' => 'TokenRule_1'
                       },
                       {
                         'rhs' => [
                                    'Lhs',
                                    'WS',
                                    'DeclareOp',
                                    'WS',
                                    'Rhs'
                                  ],
                         'lhs' => 'Rule',
                         'action' => 'Rule_0'
                       },
                       {
                         'rhs' => [
                                    'Lhs',
                                    'WS',
                                    'DeclareOp',
                                    'WS',
                                    'Rhs',
                                    'WS',
                                    'CB',
                                    'Code',
                                    'CE'
                                  ],
                         'lhs' => 'Rule',
                         'action' => 'Rule_1'
                       },
                       {
                         'rhs' => [
                                    'Name'
                                  ],
                         'lhs' => 'Lhs',
                         'action' => 'Lhs_0'
                       },
                       {
                         'rhs' => [
                                    'Names'
                                  ],
                         'lhs' => 'Rhs',
                         'action' => 'Rhs_0'
                       },
                       {
                         'rhs' => [
                                    'Names',
                                    'Star'
                                  ],
                         'lhs' => 'Rhs',
                         'action' => 'Rhs_1'
                       },
                       {
                         'rhs' => [
                                    'Names',
                                    'Plus'
                                  ],
                         'lhs' => 'Rhs',
                         'action' => 'Rhs_2'
                       },
                       {
                         'min' => 1,
                         'rhs' => [
                                    'NamePart'
                                  ],
                         'lhs' => 'Names',
                         'action' => 'Names_0'
                       },
                       {
                         'rhs' => [
                                    'WS',
                                    'Name'
                                  ],
                         'lhs' => 'NamePart',
                         'action' => 'NamePart_0'
                       },
                       {
                         'rhs' => [
                                    'WS',
                                    'Char'
                                  ],
                         'lhs' => 'NamePart',
                         'action' => 'NamePart_1'
                       },
                       {
                         'rhs' => [],
                         'lhs' => 'WS',
                         'action' => 'WS_0'
                       },
                       {
                         'rhs' => [
                                    'Space'
                                  ],
                         'lhs' => 'WS',
                         'action' => 'WS_1'
                       }
                     ]
        ,            lhs_terminals => 0,
        }
    );
    $grammar->precompute();
    return $grammar;
}
sub new {
    my ($klass) = @_;
    my $self = bless {}, $klass;
    return $self;
}

sub parse {
    my ($self, $fh) = @_;
    my $grammar = create_grammar();
    my $recognizer = Marpa::XS::Recognizer->new({ grammar => $grammar });
    my $simple_lexer = MarpaX::Simple::Lexer->new(
        recognizer     => $recognizer,
        tokens         => \%tokens,
    );
    $simple_lexer->recognize($fh);
    my $parse_tree = ${$recognizer->value};
    return $parse_tree;
}

1;

=head1 NAME

MarpaX::Parser::Marpa - Parses a Marpa grammar and creates a parser.


=head1 AUTHOR

Peter Stuifzand

=cut

