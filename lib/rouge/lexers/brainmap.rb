# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
    module Lexers
      class Brainmap < RegexLexer
        title "Brainmap"
        desc "Brainmaps for brainfrick (github.com/lukebemish/brainfrick)"

        tag 'brainmap'
        filenames '*.map'
        mimetypes 'text/x-brainnap'

        keywords = %w(
          new
        )

        declarations = %w(
          abstract extends final implements private protected
          public static put get class interface
        )

        types = %w(boolean byte char double float int long short var void)

        id = /[[:alpha:]_][[:word:]]*/
        const_name = /[[:upper:]][[:upper:][:digit:]_]*\b/
        class_name = /[[:upper:]][[:alnum:]]*\b/

        state :root do
          rule %r/[^\S\n]+/, Text
          rule %r(//.*?$), Comment::Single
          rule %r(/\*.*?\*/)m, Comment::Multiline
          # keywords: go before method names to avoid lexing "throw new XYZ"
          # as a method signature
          rule %r/(?:#{keywords.join('|')})\b/, Keyword

          rule %r(
            (\s*(?:[a-zA-Z_][a-zA-Z0-9_.\[\]<>]*\s+)+?) # return arguments
            ([a-zA-Z_][a-zA-Z0-9_]*)                  # method name
            (\s*)(\()                                 # signature start
          )mx do |m|
            # TODO: do this better, this shouldn't need a delegation
            delegate Brainmap, m[1]
            token Name::Function, m[2]
            token Text, m[3]
            token Operator, m[4]
          end

          rule %r/@\??#{id}/, Name::Decorator
          rule %r/(?:#{declarations.join('|')})\b/, Keyword::Declaration
          rule %r/(?:#{types.join('|')})\b/, Keyword::Type
          rule %r/(?:true|false)\b/, Keyword::Constant
          rule %r/"(\\\\|\\"|[^"])*"/, Str
          rule %r/'(?:\\.|[^\\]|\\u[0-9a-f]{4})'/, Str::Char
          rule %r/(\.)(#{id})/ do
            groups Operator, Name::Attribute
          end

          rule const_name, Name::Constant
          rule class_name, Name::Class
          rule %r/\$?#{id}/, Name
          rule %r/[(){},=]|(->)/, Operator

          digit = /[0-9]_+[0-9]|[0-9]/
          rule %r/#{digit}+\.#{digit}+[fd]?/, Num::Float
          rule %r/#{digit}+[lLsSbBiI]?/, Num::Integer
          rule %r/\n/, Text
        end
      end
    end
  end