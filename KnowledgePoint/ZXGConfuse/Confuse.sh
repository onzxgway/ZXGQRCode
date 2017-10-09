#!/bin/sh

#  Confuse.sh
#  KnowledgePoint
#
#  Created by san_xu on 2017/10/9.
#  Copyright © 2017年 朱献国. All rights reserved.


TABLENAME=symbols
SYMBOL_DB_FILE="symbols"
#注释掉的是常规的写法，
#STRING_SYMBOL_FILE="$PROJECT_DIR/$PROJECT_NAME/func.list"
#HEAD_FILE="$PROJECT_DIR/$PROJECT_NAME/codeObfuscation.h"
#以下两句的写法，是为了适配本Demo.
STRING_SYMBOL_FILE="$PROJECT_DIR/$TARGET_NAME/func.list"
HEAD_FILE="$PROJECT_DIR/$TARGET_NAME/codeObfuscation.h" #自动生成的codeObfuscation.h文件的位置
export LC_CTYPE=C

#取以.m或.h结尾的文件以+号或-号开头的行 |去掉所有+号或－号|用空格代替符号|n个空格跟着<号 替换成<号|开头不能是IBAction|用空格split字串取第二部分|排序|去重复|删除空行|删掉以init开头的行>写进func.list
#CONFUSE_FILE="$PROJECT_DIR/$TARGET_NAME"
#grep -h -r -I  "^[-+]" $CONFUSE_FILE  --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"| sed "/^[ ]*IBAction/d"|awk '{split($0,b," "); print b[2]; }'| sort|uniq |sed "/^$/d"|sed -n "/^XXX_/p" >$STRING_SYMBOL_FILE

#维护数据库方便日后作排重
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16
}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo '#ifndef Demo_codeObfuscation_h
#define Demo_codeObfuscation_h' >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE


sqlite3 $SYMBOL_DB_FILE .dump
