#!/usr/bin/env python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-


class EmDummy:
    """
    A template module for getting started writing an xtsv (https://github.com/nytud/xtsv) module.

    Notes on tsv header and tsv field order.
    : pass_header: pass or throw away header when generating output. (Default: True)
    : fixed_order_tsv_input: use the TSV reader code from xtsv, but without header on fixed columns.
    One may not pass the (output) header only when
     - the module is the last in the pipeline, i.e. a finalizer. See e.g. https://github.com/vadno/emconll
     - one want to continue the pipeline in fixed-order TSV mode

    Notes on JAVA.
     As some of the modules use JAVA, we need to prepare the static properties in advance.
     The following properties serve this purpose. Omit when the module does not use JAVA.
    : class_path: path to append to the end of CLASS_PATH environment variable when loading in JAVA classes
    : vm_opts: additional JAVA VM options, when needed appended to the end of the options list
    """
    pass_header = True  # TODO set or omit default: True
    fixed_order_tsv_input = False  # TODO set or omit default: False
    class_path = ''  # TODO set or omit
    vm_opts = ''  # TODO set or omit

    def __init__(self, *_, source_fields=None, target_fields=None):
        """
        The initialisation of the module. Mandatory fields are:
        :param source_fields: the set of names of the input fields
        :param target_fields: the list of names of the output fields in generation order
        These two variables obtain their value from config, see `__main__.py`
        One can extend the list of parameters as needed, see "# args" in `__main__.py`
        """
        # Custom code goes here

        # Field names for xtsv (the code below is mandatory for an xtsv module)
        if source_fields is None:
            source_fields = set()

        if target_fields is None:
            target_fields = []

        self.source_fields = source_fields
        self.target_fields = target_fields

        # if we have only 1 source field we can:
        self.source_field = next(iter(self.source_fields))

    def process_sentence(self, sen, field_info):
        """
        Process one sentence per function call.
        :param sen: the list of all tokens in the sentence, each token contain all input fields.
        :param field_info: the module-specific `field_info` from `prepare_fields()`
         to select the appropriate input field as source field and/or other stuff. If needed.
        :return: the `sen` object augmented with the output field values for each token.
        The name of the target fields are defined in `self.target_fields`.
        Functionality of this demo: add a new field containing '*' + `self.source_field`  + '*'.
        """
        for tok in sen:
            tok.append(
                '*' +
                tok[field_info[self.source_field]]
                + '*'
            )
        return sen                                   # TODO: Implement or overload on inherit

    def prepare_fields(self, field_names):
        """
        To handle field order, i.e. access source fields appropriately, regardless of input column order.
         Called once before processing the input.
        :param field_names: dict of input field names
         mapped to their column index in the input stream ordered by appearance,
         plus target field names added at the end with incrementing indices;
         and vice versa: column indices mapped to the corresponding input field name;
         to be able to convert in noth directions. 
         E.g. {'form': 0, 'wsafter': 1, 0: 'form', 1: 'wsafter'}
        :return: appropriate info about fields needed for `process_sentence()`.
        """
        # We can return...
        # 1. simply `field_names`.
        return field_names                           # TODO: Implement or overload on inherit

        # 2. a dict containing only the name->index direction.
        #return {k: v for k, v in field_names.items() if isinstance(k, str)}

        # 3. an int which is the index of the source field, if there is only one source field.
        #return field_names[next(iter(self.source_fields))]

        # 4. Alternatively, we can store field names ordered in a class variable
        #    to be able to create dicts from tokens and return `None` here.
        #self.field_order = [k for k in field_names.keys() if isinstance(k, str)]
        #return None

        # etc.


    def process_token(self, token):  # TODO implement or omit
        """
        This function is called when the REST API is called in 'one word mode' e.g. GET /stem/this_word .
        It is not mandatory. If not present but still called by the REST API an exception is raised.
        See EmMorphPy or HunspellPy for implementation example.
        :param token: the input token
        :return: the processed output of the token (preferably raw string or JSON string)
        """
        return token
