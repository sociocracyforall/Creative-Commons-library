// This script allows you to stub out topics in Discourse for a single file or
// all of the files in a particular directory.

import yargs from 'yargs';
import { hideBin } from 'yargs/helpers';

import fs from 'fs';
import { visit } from 'tree-visit';
import process from 'process';
import { join } from 'path';

import url from 'url';

import { JSDOM } from 'jsdom';

import superagent from 'superagent';

const args = yargs(hideBin(process.argv))
  .option('d', {
    alias: 'depth',
    type: 'number',
    // default: -1,
    describe: 'depth at which to stop processing',
    implies: 'directory',
  })
  .option('b', {
    alias: 'base',
    type: 'string',
    default: 'http://localhost/',
    describe: 'base URL for constructing full URLs',
  })
  .option('e', {
    alias: 'discourse',
    type: 'string',
    describe: 'Discourse posts endpoint URL',
    implies: ['key', 'username', 'category'],
  })
  .option('k', {
    alias: 'key',
    type: 'string',
    describe: 'Api-Key for Discourse web API',
    implies: ['discourse', 'username', 'category'],
  })
  .option('u', {
    alias: 'username',
    type: 'string',
    describe: 'Api-Username for Discourse',
    implies: ['discourse', 'key', 'category'],
  })
  .option('c', {
    alias: 'category',
    type: 'number',
    describe: 'ID of the category that will receive the topic',
    implies: ['discourse', 'key', 'username'],
  })
  .option('prefix', {
    type: 'string',
    describe: 'Text to add to beginning of each topic title',
    default: '',
  })
  .option('description', {
    describe: 'Text to add to the beginning of the first paragraph '
              + 'of the topic',
    default: '',
  })
  .option('directory', {
    describe: 'Process a whole directory of files',
    boolean: true,
  })
  .demandCommand(1)
  .parse();

//const build_title = function build_title(document.title) {
//};

//const build_body = function build_body(...

const topic_from_fs = function topic_from_fs(filename, indexPath) {
  const stats = fs.statSync(filename);
  if (!stats.isDirectory()) {
    const section_url = (new url.URL(filename, args.base)).href;
    const buffer = fs.readFileSync(filename);
    let { document } = new JSDOM(buffer).window;
    if (args.discourse !== undefined) {
      superagent
        .post(args.discourse)
        .accept('application/json')
        .send({
          title: args.prefix + document.title,
          raw: '# [' + document.title + '](' + section_url + ')'
            + '\n' + args.description + document.title,
          embed_url: section_url,
          category: args.category,
        })
        .set('Api-Username', args.username)
        .set('Api-Key', args.key)
        .end(function (err, res) {
          if (err !== null) {
            console.log('failed to create Discourse topic for', filename,
              ':', err);
          }
        });
    }
      
    console.log(section_url, '-', document.title);
  }
  if (args.depth !== undefined && indexPath.length >= args.depth) {
    return "skip";
  }
};
const options = { onEnter: topic_from_fs };

const fsvisit = function (filename, options) {
  options.getChildren = function dircontents(filename) {
    const stats = fs.statSync(filename);
    if (stats.isDirectory()) {
      return fs.readdirSync(filename).map(function (entry) {
        return join(filename, entry);
      });
    }

    return [];
  };

  return visit(filename, options);
};
if (args.directory) {
  fsvisit(args._[0], options);
} else {
  // Want to use find and xargs instead?  This branch is for you!
  topic_from_fs(args._[0]);
}
