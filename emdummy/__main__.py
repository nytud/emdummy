#!/usr/bin/env python3
# -*- coding: utf-8, vim: expandtab:ts=4 -*-

from xtsv import build_pipeline, parser_skeleton, jnius_config


def entrypoint(input, output, verbose=False, comments=False, header=False):

    jnius_config.classpath_show_warning = verbose  # Suppress warning.

    # Set the tagger name as in the tools dictionary
    used_tools = ['dummy']
    presets = []

    # Init and run the module as it were in xtsv

    # The relevant part of config.py
    # from emdummy import EmDummy
    em_dummy = (
        'emdummy', # module name
        'EmDummy', # class
        'EmDummy, just add stars to `form`', # friendly name used in REST API form
        (), # args (currently none)
        {
            'source_fields': {'form'}, # source field names
            'target_fields': ['star']  # target field names
        } # kwargs
    )
    tools = [
        (em_dummy, # config
            ('dummy', 'dummy-tagger', 'emDummy') # aliases
        )
    ]

    # Run the pipeline -- consisting of one single tool :)
    output.writelines(
        build_pipeline(
            input, # input
            used_tools, # used tools by alias (currently just em_dummy)
            tools,      # available tools (currently just em_dummy)
            presets,    # list of presets (currently none)
            comments # are comments allowed?
        )
    )

    # TODO this method is recommended when debugging the tool
    # Alternative: Run specific tool for input (still in emtsv format):
    # from xtsv import process
    # from emdummy import EmDummy
    # output_iterator.writelines(process(input_data, EmDummy(*em_dummy[3], **em_dummy[4])))

    # Alternative2: Run REST API debug server
    # from xtsv import pipeline_rest_api, singleton_store_factory
    # app = pipeline_rest_api('TEST', tools, {},  conll_comments=False, singleton_store=singleton_store_factory(),
    #                         form_title='TEST TITLE', doc_link='https://github.com/nytud/emdummy')
    # app.run()


def main():
    argparser = parser_skeleton(description='EmDummy - a template module for xtsv')
    opts = argparser.parse_args()

    # Set input and output iterators from command line args
    if opts.input_text is not None:
        input_data = opts.input_text
    else:
        input_data = opts.input_stream
    entrypoint(
        input=input_data,
        output=opts.output_stream,
        verbose=opts.verbose,
        comments=opts.conllu_comments,
        header=opts.output_header
    )




if __name__ == '__main__':
    main()
