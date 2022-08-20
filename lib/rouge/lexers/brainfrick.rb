# -*- coding: utf-8 -*- #
# frozen_string_literal: true

module Rouge
    module Lexers
      class Brainfrick < RegexLexer
        tag 'brainfrick'
        filenames '*.frick'
        mimetypes 'text/x-brainfrick'

        title "Brainfrick"
        desc "The brainfrick programming language (github.com/lukebemish/brainfrick)"

        state :root do
          rule %r/\/\/.*?$/, Comment::Single
          rule %r/"(\\\\|\\"|[^"])*"/, Str
          rule %r/\/\*.*?\*\//m, Comment::Multiline
          rule %r/\;{/, Punctuation, :classloop
          rule %r/[;\-]/, Punctuation
          mixin :comment_single
        end

        state :classloop do
          rule %r(//.*?$), Comment::Single
          rule %r(/\*.*?\*/)m, Comment::Multiline
          rule %r/;{/, Punctuation, :methodloop
          rule %r/{/, Punctuation, :methodloop
          rule %r/[;\-]/, Punctuation
          rule %r/}/, Punctuation, :pop!
          rule %r/\[/, Punctuation, :loop
          mixin :comment_single
        end

        state :methodloop do
            rule %r(//.*?$), Comment::Single
            rule %r(/\*.*?\*/)m, Comment::Multiline
            rule %r/}/, Punctuation, :pop!
            rule %r/\[/, Punctuation, :loop
            mixin :comment_single
            mixin :commands
        end

        state :loop do
          rule %r(//.*?$), Comment::Single
          rule %r(/\*.*?\*/)m, Comment::Multiline
          rule %r/\[/, Punctuation, :loop
          rule %r/\]/, Punctuation, :pop!
          rule %r/[><]+/, Name::Builtin
          mixin :comment_single
          mixin :commands
        end

        state :commands do
          rule %r/[><]+/, Name::Builtin
          rule %r/[+\-.,:;\/]+/, Name::Function
        end

        state :comment_single do
          rule %r/[^><+\-.,\[\]\/;:{}"]+/, Comment::Single
        end
      end
    end
  end
