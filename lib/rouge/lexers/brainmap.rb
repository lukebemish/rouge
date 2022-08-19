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

        class_name = /[a-zA-Z][a-zA-Z0-9$\.]*/
        id = /[a-zA-Z][a-zA-Z0-9$]*/

        state :root do
          rule %r/[^\S\n]+/, Text
          rule %r(//.*?$), Comment::Single
          rule %r(/\*.*?\*/)m, Comment::Multiline
          # keywords: go before method names to avoid lexing "throw new XYZ"
          # as a method signature
          rule %r/(#{keywords.join('|')})/, Keyword
          rule %r/@\??#{class_name}/, Name::Decorator
          rule %r/(?:#{declarations.join('|')})\b/, Keyword::Declaration

          rule %r/(#{types.join('|')})/, Keyword::Type
          rule %r/(true|false)/, Keyword::Constant
          rule %r/"(\\\\|\\"|[^"])*"/, Str
          rule %r/'(?:\\.|[^\\]|\\u[0-9a-f]{4})'/, Str::Char

          rule %r(#{id}(\.#{id})+), Name::Attribute

          rule %r(
              (#{id})
              (\s*)(\()
          )mx do |m|
            token Name::Function, m[1]
            token Text, m[2]
            token Operator, m[3]
          end

          rule %r(#{id}), Name::Constant

          rule class_name, Name::Attribute
          rule %r/\$?#{id}/, Name::Attribute
          rule %r/[(){},=#]|(->)/, Operator

          digit = /[0-9]_+[0-9]|[0-9]/
          rule %r/#{digit}+\.#{digit}+[fd]?/, Num::Float
          rule %r/#{digit}+[lLsSbBiI]?/, Num::Integer
          rule %r/\s/, Text
          rule %r/\n/, Text
        end
      end
    end
  end