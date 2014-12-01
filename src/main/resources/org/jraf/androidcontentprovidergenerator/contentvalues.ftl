<#if header??>
${header}
</#if>
package ${config.providerJavaPackage}.${entity.packageName};

import android.content.ContentResolver;
import android.content.ContentUris;
import android.database.Cursor;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import ${config.providerJavaPackage}.base.AbstractContentValues;

/**
 * Content values wrapper for the {@code ${entity.nameLowerCase}} table.
 */
public class ${entity.nameCamelCase}ContentValues extends AbstractContentValues {

    /**
    * Parcelable CREATOR
    */
    public static final Parcelable.Creator<${entity.nameCamelCase}ContentValues> CREATOR 
        = new Parcelable.Creator<${entity.nameCamelCase}ContentValues>() {

        public ${entity.nameCamelCase}ContentValues createFromParcel(Parcel in) {
            return new ${entity.nameCamelCase}ContentValues(in);
        }
		
        public ${entity.nameCamelCase}ContentValues[] newArray(int size) {
            return new ${entity.nameCamelCase}ContentValues[size];
        }
	};
	
    /**
    * Construct a new empty ${entity.nameCamelCase}ContentValues
    */
	public ${entity.nameCamelCase}ContentValues()
	{
		super(${entity.nameCamelCase}Columns.CONTENT_URI);
	}
	
    /**
    * Parcelable constructor
    */	private ${entity.nameCamelCase}ContentValues(Parcel in) {
		super(in);
	}
	
     /**
     * Load the values into the ${entity.nameCamelCase}ContentValues from the current position of a cursor 
     *
     * @param cursor The cursor to use.  The cursor must be ready in the position to use.
     */
    public void loadFromCursor(${entity.nameCamelCase}Cursor cursor) {
    <#list entity.fields as field>
    <#if !field.isId>
        put${field.nameCamelCase}(cursor.get${field.nameCamelCase}());
    </#if>
    </#list>
        mUri = ContentUris.withAppendedId(${entity.nameCamelCase}Columns.CONTENT_URI, cursor.getId());
    }
    
    /**
     * Load the values into the ${entity.nameCamelCase}ContentValues from the first ${entity.nameLowerCase} returned 
     * by the contentResolver for the specified uri
     *
     * @param contentResolver The content resolver to use.
     * @param uri The uri to use.
     */
    public void load(ContentResolver contentResolver, Uri uri) {
    	Cursor cursor = contentResolver.query(uri, null, null, null, null);
    	if (cursor.moveToFirst())
    	{
    		loadFromCursor(new ${entity.nameCamelCase}Cursor(cursor));
    	}
    }

    /**
     * Update row(s) using the values stored by this object and the given selection.
     *
     * @param contentResolver The content resolver to use.
     * @param where The selection to use (can be {@code null}).
     */
    public int update(ContentResolver contentResolver, ${entity.nameCamelCase}Selection where) {
        return contentResolver.update(uri(), values(), where == null ? null : where.sel(), where == null ? null : where.args());
    }
    
    /**
     * Insert a new ${entity.nameLowerCase} using the values stored by this object
     *
     * @param contentResolver The content resolver to use.
     */
    public Uri insert(ContentResolver contentResolver) {
        mUri = contentResolver.insert(${entity.nameCamelCase}Columns.CONTENT_URI, values());
        return mUri;
    }
    
    /**
     * Save the values in this ${entity.nameCamelCase}ContentValues as a new ${entity.nameLowerCase}
     * If this ${entity.nameCamelCase}ContentValues refers to an existing ${entity.nameLowerCase} then saving
     * is simply an update, otherwise it is an insert.
     *
     * @param contentResolver The content resolver to use.
     */
    public void save(ContentResolver contentResolver) {
    	if (uri() == ${entity.nameCamelCase}Columns.CONTENT_URI)
    	{
    		insert(contentResolver);
    	}
    	else
    	{
    		update(contentResolver, null);
    	}
    }

    public long getId() {
        return ContentUris.parseId(mUri);
    }
    
    <#list entity.fields as field>
        <#if !field.isId>

    <#if field.documentation??>
    /**
     * ${field.documentation}
     */
    </#if>
    public ${entity.nameCamelCase}ContentValues put${field.nameCamelCase}(${field.javaTypeSimpleName} value) {
            <#if !field.isNullable && !field.type.hasNotNullableJavaType()>
        if (value == null) throw new IllegalArgumentException("value for ${field.nameCamelCaseLowerCase} must not be null");
            </#if>
            <#switch field.type.name()>
            <#case "DATE">
        mContentValues.put(${entity.nameCamelCase}Columns.${field.nameUpperCase}, <#if field.isNullable>value == null ? null : </#if>value.getTime());
            <#break>
            <#case "ENUM">
        mContentValues.put(${entity.nameCamelCase}Columns.${field.nameUpperCase}, <#if field.isNullable>value == null ? null : </#if>value.ordinal());
            <#break>
            <#default>
        mContentValues.put(${entity.nameCamelCase}Columns.${field.nameUpperCase}, value);
            </#switch>
        return this;
    }

            <#if field.isNullable>
    public ${entity.nameCamelCase}ContentValues put${field.nameCamelCase}Null() {
        mContentValues.putNull(${entity.nameCamelCase}Columns.${field.nameUpperCase});
        return this;
    }
            </#if>

            <#switch field.type.name()>
            <#case "DATE">
    public ${entity.nameCamelCase}ContentValues put${field.nameCamelCase}(<#if field.isNullable>Long<#else>long</#if> value) {
        mContentValues.put(${entity.nameCamelCase}Columns.${field.nameUpperCase}, value);
        return this;
    }
            <#break>
            </#switch>   
    
    public ${field.javaTypeSimpleName} get${field.nameCamelCase}() {
            <#switch field.type.name()>
            <#case "DATE">
        return new Date(mContentValues.getAsLong(${entity.nameCamelCase}Columns.${field.nameUpperCase}));
            <#break>
            <#case "ENUM">
        return ${field.javaTypeSimpleName}.values()[mContentValues.getAsInteger(${entity.nameCamelCase}Columns.${field.nameUpperCase})];
            <#break>
            <#case "INTEGER">
        return mContentValues.getAsInteger(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "LONG">
        return mContentValues.getAsLong(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "FLOAT">
        return mContentValues.getAsFloat(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "DOUBLE">
        return mContentValues.getAsDouble(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "BOOLEAN">
        return mContentValues.getAsBoolean(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "BYTE_ARRAY">
        return mContentValues.getAsByteArray(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#case "STRING">
        return mContentValues.getAsString(${field.entity.nameCamelCase}Columns.${field.nameUpperCase});
            <#break>
            <#default>
        return mContentValues.get(${entity.nameCamelCase}Columns.${field.nameUpperCase});
            </#switch>
    }
        </#if>
    </#list>
}
