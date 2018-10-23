module ModalHelper
  def modal_button(id, options = {}, &block)
    link_to(
      "##{id}",
      data: { toggle: "modal", target: "##{id}" },
      class: options[:class],
      &block
    )
  end

  def modal(id, &block)
    content_tag(
      :div,
      content_tag(
        :div,
        content_tag(:div, class: "modal-content", &block), class: "modal-dialog"
      ),
      id: id, class: "modal fade"
    )
  end
end
