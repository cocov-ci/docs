class DocLinkParser
  STATE_OPEN_QUOTE = 0
  STATE_QUOTE_CONTENTS = 1
  STATE_END_OR_COMMA = 2
  STATE_PARAM_KEY = 3
  STATE_PARAM_VALUE_START = 4
  STATE_PARAM_VALUE_CONTENTS = 5

  ERROR_MESSAGES = {
    STATE_OPEN_QUOTE => "Expected double-quote indicating a page name",
    STATE_QUOTE_CONTENTS => "Unexpected end-of-tag, expected double-quote",
    STATE_END_OR_COMMA => nil,
    STATE_PARAM_KEY => "Expected parameter key after comma",
    STATE_PARAM_VALUE_START => "Expected double-quote starting value after colon",
    STATE_PARAM_VALUE_CONTENTS => "Unexpected end-of-tag, expected double-quote"
  }

  attr_reader :idx, :state

  def initialize(data)
    @data = data
    @idx = 0
    @max = data.length
    @start = 0
    @state = STATE_OPEN_QUOTE

    @link = nil
    @current_key = nil
    @opts = {}
  end

  def inc
    @idx += 1
  end

  def mark(val = nil)
    if val.nil?
      @start = @idx
    else
      @start = val
    end
  end

  def marked
    @data[@start...idx]
  end

  def transition(state)
    @state = state
  end

  def parse
    catch(:stop_parsing) { parse_one while idx < @max }
    err = ERROR_MESSAGES[state]
    raise ArgumentError, err unless err.nil?

    return {
      link: @link,
      opts: @opts,
    }
  end

  def stop
    throw :stop_parsing
  end

  def chomp_spaces
    inc while @data[idx] == ' '
    stop if idx >= @max
  end

  def ch
    @data[idx]
  end

  def parse_one
    case state
    when STATE_OPEN_QUOTE
      raise ArgumentError, "Unexpected `#{ch}', expected double-quote" if ch != '"'
      transition STATE_QUOTE_CONTENTS
      inc
      mark

    when STATE_QUOTE_CONTENTS
      if ch == '"'
        transition STATE_END_OR_COMMA
        @link = marked
      end
      inc

    when STATE_END_OR_COMMA
      chomp_spaces
      if ch != ','
        raise ArgumentError, "Unexpected `#{ch}', expected ',' or end of tag"
      end

      transition STATE_PARAM_KEY
      inc
      chomp_spaces
      mark

    when STATE_PARAM_KEY
      if ch >= 'a' && ch <= 'z'
        inc
      elsif ch == ':'
        @current_key = marked
        if @current_key.strip.empty?
          raise ArgumentError, "Unexpected `:', expected a-z+"
        end

        inc
        chomp_spaces
        transition STATE_PARAM_VALUE_START
      else
        raise ArgumentError, "Unexpected `#{ch}', expected a-z+, or ':'"
      end

    when STATE_PARAM_VALUE_START
      raise ArgumentError, "Unexpected `#{ch}, expected double-quote" if ch != '"'
      inc
      mark
      transition STATE_PARAM_VALUE_CONTENTS

    when STATE_PARAM_VALUE_CONTENTS
      if ch == '"'
        @opts[@current_key] = marked
        transition STATE_END_OR_COMMA
      end
      inc
    end
  end
end
