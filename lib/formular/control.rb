module Formular
  class Builder # i hate that, please, give use namespace Builder
    class Input
      def initialize(element)
        @element = element
      end

      def call(attributes, options, tag=:input)
        @element.tag(tag, attributes: attributes, content: options[:content]) # DISCUSS: save hash lookup for :content?
      end

      def error(attributes, options, tag=:input)
        call(attributes, options, tag)
      end
    end

    class Textarea < Input
      def call(attributes, options, tag=:textarea)
        attributes= attributes.dup # FIXME.

        content = attributes.delete(:value) || ""

        @element.tag(:textarea, attributes: attributes, content: content) # DISCUSS: save hash lookup for :content?
      end
    end

    class Checkbox < Input
      def call(attributes, options, *)
        attributes= attributes.dup # FIXME.

        attributes[:checked] = :checked if attributes[:value].to_s == toggles[:on].to_s
        attributes[:value]   = toggles[:on]

        # DISCUSS: refactor to #render
        @element.tag(:input, attributes: { type: :hidden, value: toggles[:off], name: attributes[:name] }) +
          super +
          label(attributes, options)
      end

    private
    # DISCUSS: pass in content?
      def label(attributes, options) # DISCUSS: should labels be part of a Control or a higher-level widget?
        return "" unless options[:label]
        @element.tag(:label, attributes: { for: attributes[:id] }, content: "#{options[:label]}")
      end

      def toggles
        { on: 1, off: 0}
      end
    end
  end
end
