<%@ Page Language="C#" MasterPageFile="~/Betbook.Master" AutoEventWireup="true"
CodeBehind="ViewFavourites.aspx.cs" Inherits="Es.Udc.DotNet.Betbook.Web.Pages.ViewFavourites" %>

<asp:Content ID="content" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <br />
    <p>
        <asp:Label ID="lblNoFavourites" meta:resourcekey="lblNoFavourites" runat="server"></asp:Label>
    </p>
    <form id="form" runat="server">
    <asp:GridView ID="gvViewFavourites" runat="server" GridLines="None" AutoGenerateColumns="False" CssClass="cooltable">
        <Columns>
            <asp:HyperLinkField DataTextField="name" meta:resourcekey="colFavName" DataNavigateUrlFields="eventId,name" DataNavigateUrlFormatString="~/Pages/FindBetTypes.aspx?eventId={0}&eventName={1}"/>
            <asp:BoundField DataField="comment" meta:resourcekey="colFavComment"/>
            <asp:BoundField DataField="date" meta:resourcekey="colFavDate"/>
            <asp:HyperLinkField meta:resourcekey="btnRemoveFav" DataNavigateUrlFields="favouriteId" DataNavigateUrlFormatString="~/Pages/RemoveFavourite.aspx?favouriteId={0}" />
        </Columns>
    </asp:GridView>
    </form>
    <br />
    <br />
    <!-- "Previous" and "Next" links. -->
    <div class="previousNextLinks">
        <span class="previousLink">
            <asp:HyperLink ID="lnkPrevious" Text="<%$ Resources:Common, Previous %>" runat="server"
                Visible="False"></asp:HyperLink>
        </span><span class="nextLink">
            <asp:HyperLink ID="lnkNext" Text="<%$ Resources:Common, Next %>" runat="server" Visible="False"></asp:HyperLink>
        </span>
    </div>
</asp:Content>