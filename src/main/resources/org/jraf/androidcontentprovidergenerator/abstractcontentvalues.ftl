<#if header??>
${header}
</#if>
package ${config.providerJavaPackage}.base;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.net.Uri;

public abstract class AbstractContentValues implements Parcelable
{
    protected ContentValues mContentValues;
    protected Uri mUri;
    
    /**
    * Contruct a AbstractContentValues with the specified uri
    *
    * @param uri - the uri to use
    */
    public AbstractContentValues(Uri uri)
    {
    	mContentValues = new ContentValues();
    	mUri = uri;
    }
    
    /**
    * Parcelable.writeToParcel
    */    
    public void writeToParcel(Parcel out, int flags) 
    {
    	mContentValues.writeToParcel(out, flags);
    	mUri.writeToParcel(out, flags);
    }
    
    /**
    * Parcelable constructor
    */ 
    protected AbstractContentValues(Parcel in) 
    {
    	mContentValues = ContentValues.CREATOR.createFromParcel(in);
    	mUri = Uri.CREATOR.createFromParcel(in);
    }
    
    /**
    * Parcelable.describeContents
    */ 
    public int describeContents() {
        return 0;
    }

    /**
     * Returns the {@code uri} argument to pass to the {@code ContentResolver} methods.
     */
    public Uri uri() { return mUri; }
}