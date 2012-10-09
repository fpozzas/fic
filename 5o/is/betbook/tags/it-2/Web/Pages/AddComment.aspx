<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddComment.aspx.cs"
    Inherits="Es.Udc.DotNet.Betbook.Web.Pages.AddComment" MasterPageFile="~/Betbook.Master" %>

<asp:Content ID="content2" ContentPlaceHolderID="ContentPlaceHolderMain" runat="server">
    <div id="form">
        <form id="AddCommentForm" method="post" runat="server">
        <div class="field">
            <span class="label">
                <asp:Localize ID="lclTags" runat="server" meta:resourcekey="lclTags" />
            </span>
            <span class="entry"><asp:TextBox ID="txtTags" runat="server" 
                Width="200px" Columns="16"></asp:TextBox>
            </span>
        </div>
        
        <div id="existingTagsWrapper">
            <asp:Localize ID="lclExistingTags" runat="server" meta:resourcekey="lclExistingTags" />
            <asp:ListView ID="lvTagList" runat="server"><%--OnItemCommand="LvTagList_ItemCommand"--%>
                <LayoutTemplate>
                    <div id="existingTags">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                    </div>
                </LayoutTemplate>
                <ItemTemplate>
                    <%--<asp:LinkButton ID="lnkTagAdder"
                        CommandName="addTag"
                        CommandArgument='<%# Eval("Text") %>'
                        runat="server"
                        Text='<%# Eval("Text") %>' />--%>
                    <asp:HyperLink ID="lnkTagAdder"
                        NavigateUrl='<%# GetTagLink( (string)Eval("Text") ) %>'
                        runat="server"
                        Text='<%# Eval("Text") %>' />
                </ItemTemplate>
                <EmptyDataTemplate>
                    <div id="existingTags">
                        <asp:Localize ID="lclTagNubrEmpty" meta:resourcekey="lclTagNubrEmpty" runat="server" />
                    </div>
                </EmptyDataTemplate>
            </asp:ListView>
        </div>
        
        <div class="field">
            <span class="entry">
                <textarea id="txtareaComment" runat="server" cols="20" name="S1" rows="4" />
                <asp:RequiredFieldValidator ID="rfvComment" runat="server" ControlToValidate="txtareaComment"
                    Display="Dynamic" Text="<%$ Resources: Common, mandatoryField %>"
                    CssClass="errorMessage"></asp:RequiredFieldValidator>
            </span>
        </div>
        <div class="field">
            <asp:Button ID="btnAddComment" runat="server" meta:resourcekey="btnAddComment" 
                OnClick="btnAddComment_Click" />
        </div>
        </form>
    </div>
    <br />
    <br />
</textarea></span></asp:Content>
